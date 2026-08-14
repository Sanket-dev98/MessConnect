import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_profile.dart';

/// Wraps [FirebaseAuth] for email/password and phone (OTP) sign-in.
///
/// PART 3 — supports both auth methods from Prompt.txt. The ID token obtained
/// here is persisted by the auth controller and sent by the Dio interceptor
/// (Prompt.txt integration rule #1).
class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Current ID token (force-refresh so expired tokens are renewed).
  Future<String?> idToken() async => _auth.currentUser?.getIdToken(true);

  Future<UserCredential> registerWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toMap());
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  /// Sends an OTP to [phoneNumber] (e.g. "+919999999999").
  ///
  /// [onCodeSent] receives the [verificationId] + a resend token; call
  /// [verifyOtp] with the SMS code to complete sign-in. Use Firebase
  /// "test phone numbers" in the console so the emulator can receive codes.
  Future<void> sendOtp({
    required String phoneNumber,
    required Duration timeout,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException e) onFailed,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: onAutoVerified,
      verificationFailed: onFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp(String verificationId, String smsCode) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() => _auth.signOut();
}

/// Provider for the auth repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
});
