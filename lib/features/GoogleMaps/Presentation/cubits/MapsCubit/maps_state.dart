part of 'maps_cubit.dart';

@immutable
sealed class MapsState {}

final class MapsLoading extends MapsState {}

final class MapsError extends MapsState {
  final String message;
  MapsError({required this.message});
}

final class MapsLoaded extends MapsState {
  final Set<Marker> markers;
  final LatLng? currentLocation;
  final String? pickupLocation;
  final String? destinationLocation;
  final GoogleMapController? mapController;

  MapsLoaded({
    required this.markers,
    this.currentLocation,
    this.pickupLocation,
    this.destinationLocation,
    this.mapController,
  });

  // CopyWith function to update specific fields
  MapsLoaded copyWith({
    Set<Marker>? markers,
    LatLng? currentLocation,
    String? pickupLocation,
    String? destinationLocation,
    GoogleMapController? mapController,
  }) {
    return MapsLoaded(
      markers: markers ?? this.markers,
      currentLocation: currentLocation ?? this.currentLocation,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      mapController: mapController ?? this.mapController,
    );
  }
}
final class MapsCameraMoving extends MapsState {
  final LatLng targetLocation;
  MapsCameraMoving({required this.targetLocation});
}

final class MapsCameraMoved extends MapsState {
  final LatLng targetLocation;
  MapsCameraMoved({required this.targetLocation});
}
