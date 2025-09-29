import 'package:mountain_hiking_app/src/data/repositories/auth/auth_repository.dart';

/// [MVP Refactor] 本地身份驗證倉儲 (無實際作用)
///
/// 這是 AuthRepository 的一個模擬 (Mock) 或虛設 (Dummy) 實作。
/// 在離線模式下，這個類別會被注入到 AuthBloc 中，用以取代真正的 AuthApiService。
///
/// 它的核心作用是提供一個「永遠不會登入」的狀態，例如 `getCurrentUser` 永遠返回 null。
/// 這讓 App 的其餘部分在離線時能有一個一致、可預期的未認證狀態，而無需修改上層邏輯。
class LocalAuthRepository implements AuthRepository {
  @override
  Future<String?> getCurrentUser() async {
    // In offline mode, there is never a current user.
    return null;
  }

  @override
  Future<String> login(String email, String password) {
    throw UnimplementedError('登入功能已在離線版中停用。');
  }

  @override
  Future<void> logout() async {
    // No action needed in offline mode.
    return;
  }

  @override
  Future<String> register({
    required String email,
    required String password,
    String? accountName,
    String? phoneNumber,
    String? name,
  }) {
    throw UnimplementedError('註冊功能已在離線版中停用。');
  }

  @override
  Future<void> sendPasswordResetEmail(String emailOrAccount) {
    throw UnimplementedError('密碼重設功能已在離線版中停用。');
  }

  @override
  Future<String> signInWithApple() {
    throw UnimplementedError('Apple 登入功能已在離線版中停用。');
  }

  @override
  Future<String> signInWithBiometrics() {
    throw UnimplementedError('生物辨識登入功能已在離線版中停用。');
  }

  @override
  Future<String> signInWithGoogle() {
    throw UnimplementedError('Google 登入功能已在離線版中停用。');
  }

  @override
  Future<void> resetPassword(String emailOrAccount, String newPassword, String code) {
    throw UnimplementedError('密碼重設功能已在離線版中停用。');
  }

  @override
  Future<bool> verifyPasswordResetCode(String emailOrAccount, String code) {
    throw UnimplementedError('密碼重設功能已在離線版中停用。');
  }
}
