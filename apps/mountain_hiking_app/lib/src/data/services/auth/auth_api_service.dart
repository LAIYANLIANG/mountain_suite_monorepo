import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mountain_hiking_app/src/data/repositories/auth/auth_repository.dart';

// This is the real implementation of the AuthRepository using Firebase.
class AuthApiService implements AuthRepository {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  // The constructor now accepts an instance of FirebaseAuth.
  // If not provided, it will use the default instance.
  AuthApiService({
    firebase.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
       _googleSignIn =
           googleSignIn ??
           GoogleSignIn(
             serverClientId: dotenv.isInitialized
                 ? dotenv.maybeGet('GOOGLE_SERVER_CLIENT_ID')
                 : null,
           );

  @override
  Future<String?> getCurrentUser() async {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw Exception('登入失敗，找不到使用者資訊。');
      }
      return userCredential.user!.uid;
    } on firebase.FirebaseAuthException catch (e) {
      // Provide more specific error messages based on the error code.
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('無效的帳號或密碼。');
      } else {
        throw Exception('登入時發生未知錯誤。');
      }
    }
  }

  @override
  Future<String> register({
    required String email,
    required String password,
    String? accountName,
    String? phoneNumber,
    String? name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw Exception('註冊失敗，無法建立使用者。');
      }
      // Optionally, update the user's profile with the provided name.
      if (name != null) {
        await userCredential.user!.updateDisplayName(name);
      }
      // In a real app, you might want to store accountName and phoneNumber in Firestore.
      return userCredential.user!.uid;
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('密碼強度不足。');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('此電子郵件已被註冊。');
      } else {
        throw Exception('註冊時發生未知錯誤。');
      }
    }
  }

  @override
  Future<void> logout() async {
    // Also sign out from Google if the user signed in with Google.
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String emailOrAccount) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailOrAccount);
    } on firebase.FirebaseAuthException catch (e) {
      // Avoid revealing if the user exists.
      print('Error sending password reset email: ${e.code}');
      // Silently fail or show a generic message to the user.
      throw Exception('無法發送密碼重設郵件，請稍後再試。');
    }
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
            final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        throw Exception('Google 登入已取消。');
      }
      // 取得認證詳細資料
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // 建立 Firebase 認證憑證
      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('Google 登入失敗，找不到使用者資訊。');
      }
      return userCredential.user!.uid;
    } catch (e) {
      // Handle exceptions, e.g., network errors
      throw Exception('Google 登入時發生錯誤: $e');
    }
  }

  // --- The following methods are not implemented in this step ---

  @override
  Future<bool> verifyPasswordResetCode(String emailOrAccount, String code) async {
    // Firebase handles this via a link in the email, not a manual code verification in the app.
    throw UnimplementedError('Firebase 密碼重設流程是透過電子郵件連結，不支援此方法。');
  }

  @override
  Future<void> resetPassword(String emailOrAccount, String newPassword, String code) async {
    // Firebase handles this via a link in the email.
    throw UnimplementedError('Firebase 密碼重設流程是透過電子郵件連結，不支援此方法。');
  }

  @override
  Future<String> signInWithApple() async {
    // Requires specific setup for Apple Sign In.
    throw UnimplementedError('Apple 登入功能尚未實作。');
  }

  @override
  Future<String> signInWithBiometrics() async {
    // Requires saving credentials securely and using local_auth.
    throw UnimplementedError('生物辨識登入功能尚未實作。');
  }
}