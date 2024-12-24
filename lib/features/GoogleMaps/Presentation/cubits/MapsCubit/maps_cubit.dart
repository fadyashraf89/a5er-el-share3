import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  GoogleMapController? _mapController;

  MapsCubit()
      : super(MapsLoaded(
    markers: const {},
    currentLocation: null,
    pickupLocation: null,
    destinationLocation: null,
    mapController: null,
  ));

  // Set the Google map controller
  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;

    // Update the existing MapsLoaded state with the controller
    if (state is MapsLoaded) {
      emit((state as MapsLoaded).copyWith(mapController: mapController));
    }
  }

  // Get the current location and add a marker
  Future<void> getCurrentLocation({bool isPickup = true}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services are disabled.");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Reverse geocode for address
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      String locationName = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}"
          : "Unknown Location";

      // Update the current location in state
      updateCurrentLocation(newLocation, locationName, isPickup);
    } catch (e) {
      emit(MapsError(message: e.toString()));
    }
  }

  void addMarker(LatLng position, String title, MarkerId markerId, {required bool isPickup}) async {
    print("Adding Markers");

    // Get the current state
    final currentState = state as MapsLoaded;

    // Update markers and locations
    if (state is MapsLoaded) {
      final updatedMarkers = Set<Marker>.from(currentState.markers)
        ..removeWhere((marker) => marker.markerId == markerId) // Remove existing marker if updating
        ..add(Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: title),
        ));

      // Adjust the camera view based on the number of markers
      if (_mapController != null) {
        if (updatedMarkers.length == 2) {
          // If there are two markers, adjust the camera to fit both markers
          final latitudes = updatedMarkers.map((m) => m.position.latitude).toList();
          final longitudes = updatedMarkers.map((m) => m.position.longitude).toList();

          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(
              latitudes.reduce((a, b) => a < b ? a : b),
              longitudes.reduce((a, b) => a < b ? a : b),
            ),
            northeast: LatLng(
              latitudes.reduce((a, b) => a > b ? a : b),
              longitudes.reduce((a, b) => a > b ? a : b),
            ),
          );

          emit(MapsCameraMoving(targetLocation: position));

          // Animate the camera to fit the bounds
          await _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

          // Calculate the center of the bounds
          LatLng center = LatLng(
            (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
          );

          // Emit camera moved state
          emit(MapsCameraMoved(targetLocation: center));
        } else {
          // Move the camera to the specific marker's position if there aren't two markers
          await _mapController!
              .animateCamera(CameraUpdate.newLatLngZoom(position, 16.0));
          emit(MapsCameraMoving(targetLocation: position));
        }
      }

      // Emit the new state with updated markers and locations
      emit(currentState.copyWith(
        currentLocation: position,
        pickupLocation: isPickup ? title : currentState.pickupLocation,
        destinationLocation: isPickup ? currentState.destinationLocation : title,
        markers: updatedMarkers,
      ));
    }
  }

  void updateCurrentLocation(
      LatLng location, String locationName, bool isPickup) {
    if (state is MapsLoaded) {
      final currentState = state as MapsLoaded;

      // Determine which marker ID to use
      MarkerId markerId =
      isPickup ? const MarkerId('pickup') : const MarkerId('destination');

      // Add the marker on the map
      addMarker(location, locationName, markerId, isPickup: isPickup);

      // Emit updated state with both pickup and destination fields
      emit(currentState.copyWith(
        currentLocation: location,
        pickupLocation: isPickup ? locationName : currentState.pickupLocation,
        destinationLocation: isPickup
            ? currentState.destinationLocation
            : locationName,
        markers: {
          ...currentState.markers,
          Marker(
            markerId: markerId,
            position: location,
            infoWindow: InfoWindow(title: locationName),
          ),
        },
      ));
    } else {
      emit(MapsError(message: "Cannot update location. Maps not fully loaded."));
    }
  }

}
