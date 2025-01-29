import 'package:a5er_elshare3/features/GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsView extends StatefulWidget {
  final Function(GoogleMapController)? onMapCreated;
  late LatLng? currentLocation;
  final Set<Marker> markers;
  MapsView({
    super.key,
    this.onMapCreated,
    this.currentLocation,
    this.markers = const {},
  });



  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {

  Future<void> _checkPermissions() async {
    // Check location permission status
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      // Permissions are granted, proceed with loading current location
      print("Location permission granted");

      // Optionally fetch the current location
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        widget.currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
      });
    } else if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      // Request for location permission if it's denied or permanently denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required to use this feature')),
      );
      openAppSettings(); // Optionally navigate to app settings to allow permissions
    }
  }
  @override
  void dispose() {
    widget.markers.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapsCubit, MapsState>(
        listener: (context, state) {
          if (state is MapsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MapsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MapsLoaded) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: state.currentLocation ??
                    const LatLng(30.048086873879566, 31.21272666931322),
                zoom: 13.0,
              ),
              myLocationEnabled: true,
              markers: state.markers,
              onMapCreated: (controller) {
                widget.onMapCreated?.call(controller);
                context.read<MapsCubit>().setMapController(controller);
              },
              zoomControlsEnabled: false,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
            );
          } else {
           return const Center(child: Text('Initializing Map...'));
          }
        },
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    // Request location permissions
    _checkPermissions();
  }


}
