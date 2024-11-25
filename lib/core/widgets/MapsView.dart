import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart' as p;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final _center = const LatLng(30.048086873879566, 31.21272666931322);
  final _markers = <Marker>{};
  GoogleMapController? _mapController;
  LatLng? _currentLocation; // To store the current location

  final places = p.GoogleMapsPlaces(
      apiKey: 'AIzaSyB2Gf-Kmp_RjoAIUbJV9Dz1m3pbTWK02vA'); // Replace with secure API key.

  Future<void> _getCurrentLocation(TextEditingController controller) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    // Fetch the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update the controller with the location
      controller.text = "Lat: ${position.latitude}, Long: ${position.longitude}";

      // Update the current location
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.clear(); // Clear old markers
        _markers.add(Marker(
          markerId: MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: 'Your Location'),
        ));
        // Move camera to the user's current location
        _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
              myLocationEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              zoomControlsEnabled: false, // Removes zoom controls
              compassEnabled: false, // Removes compass button
              myLocationButtonEnabled: false, // Removes "My Location" button
              mapToolbarEnabled: false, // Removes map toolbar (navigation and directions)
            ),
            Positioned(
              top: 40,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: Builder(
                  builder: (innerContext) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.blue),
                    onPressed: () => Scaffold.of(innerContext).openDrawer(),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  TextEditingController pickUpController =
                  TextEditingController();
                  _getCurrentLocation(pickUpController);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Get Current Location",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
