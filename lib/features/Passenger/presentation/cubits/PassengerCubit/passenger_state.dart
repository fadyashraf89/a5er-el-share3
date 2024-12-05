part of 'passenger_cubit.dart';

@immutable
sealed class PassengerState {}

final class PassengerInitial extends PassengerState {}
final class PassengerLoading extends PassengerState {}
final class PassengerSuccess extends PassengerState {}
final class PassengerError extends PassengerState {}
