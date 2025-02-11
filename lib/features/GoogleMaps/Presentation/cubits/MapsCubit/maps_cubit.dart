import 'package:a5er_elshare3/core/utils/Constants/constants.dart';
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

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;

    if (state is MapsLoaded) {
      emit((state as MapsLoaded).copyWith(mapController: mapController));
    }
  }

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

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng newLocation = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      String locationName = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}"
          : "Unknown Location";

      updateCurrentLocation(newLocation, locationName, isPickup);
    } catch (e) {
      emit(MapsError(message: e.toString()));
    }
  }

  void addMarker(LatLng position, String title, MarkerId markerId, {required bool isPickup}) async {
    print("Adding Markers");

    final currentState = state as MapsLoaded;

    if (state is MapsLoaded) {
      final updatedMarkers = Set<Marker>.from(currentState.markers)
        ..removeWhere((marker) => marker.markerId == markerId)
        ..add(Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: title),
        ));

      if (_mapController != null) {
        if (updatedMarkers.length == 2) {
          LatLngBounds bounds = CalculateBounds(updatedMarkers);

          emit(MapsCameraMoving(targetLocation: position));

          await _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

          LatLng center = LatLng(
            (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
          );

          emit(MapsCameraMoved(targetLocation: center));
        } else {
          await _mapController!
              .animateCamera(CameraUpdate.newLatLngZoom(position, 16.0));
          emit(MapsCameraMoving(targetLocation: position));
        }
      }

      emit(currentState.copyWith(
        currentLocation: position,
        pickupLocation: isPickup ? title : currentState.pickupLocation,
        destinationLocation: isPickup ? currentState.destinationLocation : title,
        markers: updatedMarkers,
      ));
    }
  }

  LatLngBounds CalculateBounds(Set<Marker> updatedMarkers) {
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
    return bounds;
  }

  void updateCurrentLocation(
      LatLng location, String locationName, bool isPickup) {
    if (state is MapsLoaded) {
      final currentState = state as MapsLoaded;

      MarkerId markerId =
      isPickup ? const MarkerId(kPickupId) : const MarkerId(kDestinationId);

      addMarker(location, locationName, markerId, isPickup: isPickup);

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
