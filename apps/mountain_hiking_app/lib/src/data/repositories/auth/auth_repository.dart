abstract class AuthRepository {
  Future<String?> getCurrentUser();
  Future<String> login(String email, String password);
  Future<String> register({
    required String email,
    required String password,
    String? accountName,
    String? phoneNumber,
    String? name,
  });
  Future<void> sendPasswordResetEmail(String emailOrAccount);
  Future<bool> verifyPasswordResetCode(String emailOrAccount, String code);
  Future<void> resetPassword(String emailOrAccount, String newPassword, String code);
  Future<String> signInWithGoogle();
  Future<String> signInWithApple();
  Future<String> signInWithBiometrics();
  Future<void> logout();
}
