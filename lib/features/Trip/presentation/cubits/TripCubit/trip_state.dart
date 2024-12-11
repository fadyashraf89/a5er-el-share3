part of 'trip_cubit.dart';

@immutable
sealed class TripState {}

final class TripInitial extends TripState {}

final class TripLoading extends TripState {}

class TripRequestSuccess extends TripState {
  final String message;

  TripRequestSuccess(this.message);
}

class TripDataFetched extends TripState {
  final List<Trip> trips;
  TripDataFetched(this.trips);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}

class TripRequestFailed extends TripState {
  final String message;
  TripRequestFailed(this.message);
}

class TripRequested extends TripState {
  final Trip trip;
  TripRequested(this.trip);
}

class TripAccepted extends TripState {
  final Trip trip;
  TripAccepted(this.trip);
}

class TripInProgress extends TripState {
  final Trip trip;
  TripInProgress(this.trip);
}

class TripCompleted extends TripState {
  final Trip trip;

  TripCompleted(this.trip);
}

class TripRejected extends TripState {
  final String? message;
  final Trip? trip;
  TripRejected({this.message, this.trip});
}

class DriverAssigned extends TripState {
  final Driver driver;
  DriverAssigned(this.driver);
}
