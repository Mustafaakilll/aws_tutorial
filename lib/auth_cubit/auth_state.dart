part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class UnknownState extends AuthState {}

class ConfirmState extends AuthState {
  ConfirmState(this.username);

  final String username;
}

class UnauthenticatedState extends AuthState {
  UnauthenticatedState({this.error});

  final String error;
}

class AuthenticatedState extends AuthState {
  AuthenticatedState(this.userId);

  final String userId;
}

class ErrorAuthState extends AuthState {
  ErrorAuthState(this.exception);

  final Exception exception;
}
