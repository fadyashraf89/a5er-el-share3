part of 'driver_cubit.dart';

@immutable
sealed class DriverState {}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverLoaded extends DriverState {
  final Driver driver;

  DriverLoaded({required this.driver});
}

class DriverUpdating extends DriverState {}

class DriverUpdated extends DriverState {
  final Driver driver;
  DriverUpdated({required this.driver});
}

class DriverError extends DriverState {
  final String message;

  DriverError({required this.message});
}