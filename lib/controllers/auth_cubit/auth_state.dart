part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}
final class AuthSocialLoading extends AuthState {}

final class AuthLoaded extends AuthState {
  final String userType;

  AuthLoaded({required this.userType});
}

final class AuthSocialLoaded extends AuthState {
  final bool? isLoaded;
  final String userType;

  AuthSocialLoaded({required this.isLoaded, required this.userType});
}

final class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});
}
