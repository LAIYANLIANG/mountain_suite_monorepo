import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mountain_hiking_app/src/data/repositories/auth/auth_repository.dart';

import 'package:mountain_hiking_app/src/business_logic/auth/auth_state.dart';

export 'auth_state.dart'; // Export AuthState and its subclasses
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final String? userId = await _authRepository.getCurrentUser();
        if (userId != null) {
          emit(AuthAuthenticated(userId));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) async {
      emit(AuthAuthenticated(event.userId));
    });

    on<AuthLoggedOut>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.logout();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(AuthAuthenticated(state is AuthAuthenticated ? (state as AuthAuthenticated).userId : ''));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await _authRepository.login(event.email, event.password);
        emit(LoginSuccess());
        emit(AuthAuthenticated(userId));
      } catch (e) {
        emit(LoginFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<LoginWithGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await _authRepository.signInWithGoogle();
        emit(LoginSuccess());
        emit(AuthAuthenticated(userId));
      } catch (e) {
        emit(LoginFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<LoginWithAppleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await _authRepository.signInWithApple();
        emit(LoginSuccess());
        emit(AuthAuthenticated(userId));
      } catch (e) {
        emit(LoginFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<LoginWithBiometricsRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await _authRepository.signInWithBiometrics();
        emit(LoginSuccess());
        emit(AuthAuthenticated(userId));
      } catch (e) {
        emit(LoginFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.register(
          email: event.email,
          password: event.password,
          accountName: event.accountName,
          phoneNumber: event.phoneNumber,
          name: event.name,
        );
        emit(RegisterSuccess());
        emit(EmailVerificationPending());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<RegisterWithGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await _authRepository.signInWithGoogle();
        emit(RegisterSuccess());
        emit(AuthAuthenticated(userId));
      } catch (e) {
        emit(RegisterFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<RegisterWithAppleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userId = await _authRepository.signInWithApple();
        emit(RegisterSuccess());
        emit(AuthAuthenticated(userId));
      } catch (e) {
        emit(RegisterFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.sendPasswordResetEmail(event.emailOrAccount);
        emit(ForgotPasswordCodeSent(event.emailOrAccount));
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });

    on<VerifyPasswordResetCode>((event, emit) async {
      emit(AuthLoading());
      try {
        final verified = await _authRepository.verifyPasswordResetCode(event.emailOrAccount, event.code);
        if (verified) {
          emit(ForgotPasswordCodeVerified(event.emailOrAccount));
        } else {
          emit(ForgotPasswordFailure('Invalid verification code.'));
        }
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.resetPassword(event.emailOrAccount, event.newPassword, event.code);
        emit(ForgotPasswordResetSuccess());
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });
  }
}