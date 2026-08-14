import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the Firebase ID token locally so the Dio client can attach it to
/// outgoing requests (Prompt.txt integration rule #1).
///
/// PART 3: backed by [flutter_secure_storage] (Android Keystore / iOS
/// Keychain) instead of the PART 1 in-memory placeholder.
abstract class TokenStorage {
  Future<void> saveIdToken(String token);
  Future<String?> readIdToken();
  Future<void> clear();
}

/// Default [TokenStorage] implementation using OS secure storage.
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _idTokenKey = 'firebase_id_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveIdToken(String token) =>
      _storage.write(key: _idTokenKey, value: token);

  @override
  Future<String?> readIdToken() => _storage.read(key: _idTokenKey);

  @override
  Future<void> clear() => _storage.delete(key: _idTokenKey);
}

/// Provider exposing the token storage singleton.
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage();
});
