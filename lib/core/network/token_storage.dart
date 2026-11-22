import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the login token in the Android Keystore, never in plain storage.
///
/// The token is cached in memory after the first read so each request does
/// not hit the Keystore again.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';

  String? _cachedToken;
  bool _loaded = false;

  Future<String?> readToken() async {
    if (!_loaded) {
      _cachedToken = await _storage.read(key: _tokenKey);
      _loaded = true;
    }
    return _cachedToken;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _cachedToken = token;
    _loaded = true;
  }

  Future<void> deleteToken() async {
    _cachedToken = null;
    _loaded = true;
    await _storage.delete(key: _tokenKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(const FlutterSecureStorage()),
);
