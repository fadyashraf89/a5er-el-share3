import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  // Singleton implementation
  static final MapsView _instance = MapsView._internal();

  factory MapsView({
    required Function(GoogleMapController) onMapCreated,
    LatLng? currentLocation,
    Set<Marker> markers = const {},
  }) {
    // Update the properties of the singleton instance if needed
    _instance._onMapCreated = onMapCreated;
    _instance._currentLocation = currentLocation;
    _instance._markers = markers;
    return _instance;
  }

  MapsView._internal(); // Private named constructor for singleton

  // Default properties
  final LatLng _center = const LatLng(30.048086873879566, 31.21272666931322);
  Set<Marker> _markers = const {};
  LatLng? _currentLocation;
  late Function(GoogleMapController) _onMapCreated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
            myLocationEnabled: false,
            markers: _markers,
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: false,
            compassEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
          ),
        ],
      ),
    );
  }
}
