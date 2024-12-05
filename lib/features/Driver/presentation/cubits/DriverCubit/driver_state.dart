part of 'driver_cubit.dart';

@immutable
sealed class DriverState {}

final class DriverInitial extends DriverState {}
final class DriverLoading extends DriverState {}
final class DriverSuccess extends DriverState {}
final class DriverError extends DriverState {}

