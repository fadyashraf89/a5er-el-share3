import 'package:a5er_elshare3/features/GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  final Function(GoogleMapController)? onMapCreated;
  final LatLng? currentLocation;
  final Set<Marker> markers;
  const MapsView({
    super.key,
    this.onMapCreated,
    this.currentLocation,
    this.markers = const {},
  });

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
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
}
