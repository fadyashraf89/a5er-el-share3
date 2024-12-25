import 'package:a5er_elshare3/features/GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatelessWidget {
  final Function(GoogleMapController)? onMapCreated;
  final LatLng? currentLocation;
  final Set<Marker> markers;

  const MapsView({
    Key? key,
    this.onMapCreated,
    this.currentLocation,
    this.markers = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapsCubit, MapsState>(
        listener: (context, state) {
          if (state is MapsError) {
            // Show an error message or take any required action in case of an error.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MapsCameraMoved) {
            // Handle camera moved state (if needed)
          }
        },
        builder: (context, state) {
          if (state is MapsLoading) {
            // Show loading state, like a loading spinner or something.
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapsError) {
            // Show error message as fallback
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MapsLoaded) {
            // When the map is loaded and the markers are available
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: state.currentLocation ??
                    const LatLng(30.048086873879566, 31.21272666931322),
                zoom: 13.0,
              ),
              myLocationEnabled: true,
              markers: state.markers,
              onMapCreated: (controller) {
                // Notify the parent or cubit about the created map controller
                onMapCreated?.call(controller);
                context.read<MapsCubit>().setMapController(controller);
              },
              zoomControlsEnabled: false,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
            );
          } else {
            // Handle the initial or empty state
            return const Center(child: Text('Initializing Map...'));
          }
        },
      ),
    );
  }
}
