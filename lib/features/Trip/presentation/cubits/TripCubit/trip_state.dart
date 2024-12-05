part of 'trip_cubit.dart';

@immutable
sealed class TripState {}

final class TripInitial extends TripState {}
final class TripLoading extends TripState {}
final class TripAccepted extends TripState {}
final class TripRejected extends TripState {}
final class TripError extends TripState {}


