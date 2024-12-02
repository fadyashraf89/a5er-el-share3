import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  const MapsView({
    Key? key,
    required this.onMapCreated,
    this.currentLocation,
    this.markers = const {},


  }) : super(key: key);

  final LatLng _center = const LatLng(30.048086873879566, 31.21272666931322);
  final Set<Marker> markers;
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
            onMapCreated: onMapCreated,
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
