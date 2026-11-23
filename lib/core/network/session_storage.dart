import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the login session (token + user data from the server) in the
/// Android Keystore, never in plain storage. Both are deleted together.
///
/// The token is cached in memory after the first read so each request does
/// not hit the Keystore again.
class SessionStorage {
  SessionStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  String? _cachedToken;
  bool _loaded = false;

  Future<String?> readToken() async {
    if (!_loaded) {
      _cachedToken = await _storage.read(key: _tokenKey);
      _loaded = true;
    }
    return _cachedToken;
  }

  /// The user JSON saved at login, or null when missing or unreadable.
  Future<Map<String, Object?>?> readUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, Object?> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> saveSession({
    required String token,
    required Map<String, Object?> user,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: jsonEncode(user));
    _cachedToken = token;
    _loaded = true;
  }

  Future<void> clearSession() async {
    _cachedToken = null;
    _loaded = true;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SessionStorage(const FlutterSecureStorage()),
);
