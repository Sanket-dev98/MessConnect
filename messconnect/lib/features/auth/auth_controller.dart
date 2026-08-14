import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_profile.dart';
import '../../services/storage/token_storage.dart';
import 'auth_repository.dart';

/// Holds the current [User?] auth state and keeps the ID token synced to
/// [TokenStorage] so the Dio interceptor can attach it to every request.
class AuthController extends AsyncNotifier<User?> {
  late final AuthRepository _repo;
  late final TokenStorage _storage;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);
    _storage = ref.watch(tokenStorageProvider);

    // Seed token for an already-signed-in user (e.g. app restart).
    final existing = _repo.currentUser;
    if (existing != null) {
      final token = await existing.getIdToken();
      if (token != null) await _storage.saveIdToken(token);
    }

    // React to future sign-in / sign-out.
    _repo.authStateChanges.listen((user) async {
      if (user != null) {
        final token = await user.getIdToken();
        if (token != null) await _storage.saveIdToken(token);
      } else {
        await _storage.clear();
      }
      // Update state directly.
      state = AsyncData(user);
    });

    return existing;
  }

  Future<void> registerWithEmail(
    String email,
    String password, {
    required UserRole role,
    String? messName,
    String? contactNo,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final cred = await _repo.registerWithEmail(email, password);
      final user = cred.user;
      if (user != null) {
        final profile = UserProfile(
          uid: user.uid,
          email: email,
          role: role,
          messName: messName,
          contactNo: contactNo,
        );
        await _repo.saveUserProfile(profile);
      }
      return user;
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final cred = await _repo.signInWithEmail(email, password);
      return cred.user;
    });
  }

  Future<UserCredential> verifyOtp(String verificationId, String smsCode) async {
    state = const AsyncLoading();
    final result =
        await AsyncValue.guard(() => _repo.verifyOtp(verificationId, smsCode));

    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      throw result.error!;
    }

    state = AsyncData(result.value!.user);
    return result.value!;
  }

  Future<void> signOut() async {
    await _repo.signOut();
    await _storage.clear();
    state = const AsyncData(null);
  }
}

/// Provider exposing auth state + actions.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);

/// Provider that fetches the profile for the currently signed-in user.
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(authControllerProvider).valueOrNull;
  if (user == null) return null;
  return ref.read(authRepositoryProvider).getUserProfile(user.uid);
});
