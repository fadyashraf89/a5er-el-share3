import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  MapsView({
    Key? key,
    required this.onMapCreated,
    this.currentLocation,
    this.markers = const {}, // Accept markers through the constructor


  }) : super(key: key);

  final LatLng _center = const LatLng(30.048086873879566, 31.21272666931322); // Default location
  final Set<Marker> markers; // Expose markers as a configurable parameter
  final LatLng? currentLocation;

  final Function(GoogleMapController) onMapCreated;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
            myLocationEnabled: false,
            markers: markers,
            onMapCreated: onMapCreated, // Use the callback to send the controller
            zoomControlsEnabled: false, // Removes zoom controls
            compassEnabled: false, // Removes compass button
            myLocationButtonEnabled: false, // Removes "My Location" button
            mapToolbarEnabled: false, // Removes map toolbar (navigation and directions)
          ),
        ],
      ),
    );
  }
}
