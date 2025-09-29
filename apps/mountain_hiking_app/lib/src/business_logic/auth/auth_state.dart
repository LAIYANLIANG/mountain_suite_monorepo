import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated(this.userId);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Login States
class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String error;
  LoginFailure(this.error);
}

// Registration States
class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final String error;
  RegisterFailure(this.error);
}

class EmailVerificationPending extends AuthState {}

// Forgot Password States
class ForgotPasswordCodeSent extends AuthState {
  final String emailOrAccount;
  ForgotPasswordCodeSent(this.emailOrAccount);
}

class ForgotPasswordCodeVerified extends AuthState {
  final String emailOrAccount;
  ForgotPasswordCodeVerified(this.emailOrAccount);
}

class ForgotPasswordResetSuccess extends AuthState {}

class ForgotPasswordFailure extends AuthState {
  final String error;
  ForgotPasswordFailure(this.error);
}
