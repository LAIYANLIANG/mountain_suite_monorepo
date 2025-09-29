part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String userId;
  AuthLoggedIn(this.userId);
}

class AuthLoggedOut extends AuthEvent {}

// Login Events
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class LoginWithGoogleRequested extends AuthEvent {}

class LoginWithAppleRequested extends AuthEvent {}

class LoginWithBiometricsRequested extends AuthEvent {}

// Registration Events
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? accountName;
  final String? phoneNumber;
  final String? name;
  RegisterRequested({
    required this.email,
    required this.password,
    this.accountName,
    this.phoneNumber,
    this.name,
  });
}

class RegisterWithGoogleRequested extends AuthEvent {}

class RegisterWithAppleRequested extends AuthEvent {}

// Forgot Password Events
class ForgotPasswordRequested extends AuthEvent {
  final String emailOrAccount;
  ForgotPasswordRequested({required this.emailOrAccount});
}

class VerifyPasswordResetCode extends AuthEvent {
  final String emailOrAccount;
  final String code;
  VerifyPasswordResetCode({required this.emailOrAccount, required this.code});
}

class ResetPasswordRequested extends AuthEvent {
  final String emailOrAccount;
  final String newPassword;
  final String code; // Assuming code is needed for the final reset
  ResetPasswordRequested({
    required this.emailOrAccount,
    required this.newPassword,
    required this.code,
  });
}
