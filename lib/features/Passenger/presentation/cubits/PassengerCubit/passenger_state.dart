part of 'passenger_cubit.dart';

@immutable
abstract class PassengerState {}

class PassengerInitial extends PassengerState {}

class PassengerLoading extends PassengerState {}

class PassengerLoaded extends PassengerState {
  final Passenger passenger;

  PassengerLoaded({required this.passenger});
}

class PassengerUpdating extends PassengerState {}

class PassengerUpdated extends PassengerState {
  final Passenger passenger;

  PassengerUpdated({required this.passenger});
}

class PassengerError extends PassengerState {
  final String message;

  PassengerError({required this.message});
}
