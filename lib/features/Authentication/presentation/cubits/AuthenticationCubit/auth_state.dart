part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final String? role;
  AuthSuccess({this.role});
}
final class AuthFailure extends AuthState {
  final String message; // Error message to be displayed.
  AuthFailure({required this.message});
}
