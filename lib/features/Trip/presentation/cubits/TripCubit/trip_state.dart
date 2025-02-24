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
  final Passenger? passenger;
  TripDataFetched(this.trips, {this.passenger});
}

class TripHistoryFetched extends TripState {
  final List<Trip> trips;
  final Passenger? passenger;
  TripHistoryFetched(this.trips, {this.passenger});
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}

class TripActive extends TripState {
  final Trip trip;
  final Duration expiryDuration;
  final Passenger? passenger;
  TripActive(this.trip, this.expiryDuration, {this.passenger});
}

class TripExpired extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripExpired(this.trip, {this.passenger});
}

class TripRequestFailed extends TripState {
  final String message;
  TripRequestFailed(this.message);
}

class TripRequested extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripRequested(this.trip, {this.passenger});
}

class TripAccepted extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripAccepted(this.trip, {this.passenger});
}

class TripInProgress extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripInProgress(this.trip, {this.passenger});
}

class TripCompleted extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripCompleted(this.trip, {this.passenger});
}

class TripRejected extends TripState {
  final String? message;
  final Trip? trip;
  final Passenger? passenger;
  TripRejected({this.message, this.trip, this.passenger});
}

class DriverAssigned extends TripState {
  final Driver driver;
  final Passenger? passenger;
  DriverAssigned(this.driver, {this.passenger});
}

class TripStarted extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripStarted(this.trip, {this.passenger});
}

class TripFinished extends TripState {
  final Trip trip;
  final Passenger? passenger;
  TripFinished(this.trip, {this.passenger});
}

class TripDismissed extends TripState {
  final Trip trip;
  final Driver driver;
  final Passenger? passenger;
  TripDismissed(this.trip, this.driver, {this.passenger});
}
