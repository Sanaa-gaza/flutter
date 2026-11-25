import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/dio_failure_mapper.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';
import 'package:flutter_sanaa_app/features/auth/domain/auth_repository.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';

/// Written against the web API shapes. Adapt it when the backend sends the
/// mobile app API (see CLAUDE.md, API strategy).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._sessionStorage);

  final Dio _dio;
  final SessionStorage _sessionStorage;

  @override
  Future<User> login({required String email, required String password}) async {
    // The password lives only in this request; it is never stored.
    final data = await _post('/auth/login', {
      'email': email.trim(),
      'password': password,
      // No "remember me" in the app design: stay logged in until logout.
      'remember': true,
    });
    return _saveSession(data);
  }

  @override
  Future<User?> savedUser() async {
    final token = await _sessionStorage.readToken();
    if (token == null) return null;
    final user = User.fromJson(await _sessionStorage.readUser());
    // A broken saved session is cleared instead of half-used.
    if (user == null) await _sessionStorage.clearSession();
    return user;
  }

  @override
  Future<VerificationResult> verifyEmail({
    required String email,
    required String code,
    required VerificationPurpose purpose,
  }) async {
    final data = await _post('/auth/verify-email', {
      'email': email.trim(),
      'code': code,
      'purpose': purpose.apiName,
    });
    switch (purpose) {
      case VerificationPurpose.register:
        return VerifiedSession(await _saveSession(data));
      case VerificationPurpose.reset:
        final resetToken = data is Map ? data['reset_token'] : null;
        if (resetToken is! String || resetToken.isEmpty) {
          throw const ServerFailure();
        }
        return ResetAllowed(resetToken);
    }
  }

  @override
  Future<void> resendCode({
    required String email,
    required VerificationPurpose purpose,
  }) => _post('/auth/resend-code', {
    'email': email.trim(),
    'purpose': purpose.apiName,
  });

  @override
  Future<void> forgotPassword({required String email}) =>
      _post('/auth/forgot-password', {'email': email.trim()});

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) => _post('/auth/reset-password', {
    'reset_token': resetToken,
    'password': password,
    'password_confirmation': passwordConfirmation,
  });

  /// Sends the request and returns the `data` part of the response.
  Future<Object?> _post(String path, Map<String, Object?> body) async {
    try {
      final response = await _dio.post<Object?>(path, data: body);
      final responseBody = response.data;
      return responseBody is Map ? responseBody['data'] : null;
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  Future<User> _saveSession(Object? data) async {
    final token = data is Map ? data['token'] : null;
    final user = User.fromJson(data is Map ? data['user'] : null);
    if (token is! String || token.isEmpty || user == null) {
      throw const ServerFailure();
    }
    await _sessionStorage.saveSession(token: token, user: user.toJson());
    return user;
  }
}
