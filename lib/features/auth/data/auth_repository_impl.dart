import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/dio_failure_mapper.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';
import 'package:flutter_sanaa_app/features/auth/domain/auth_repository.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._sessionStorage);

  final Dio _dio;
  final SessionStorage _sessionStorage;

  @override
  Future<User> login({required String email, required String password}) async {
    final Response<Object?> response;
    try {
      // The password lives only in this request; it is never stored.
      response = await _dio.post<Object?>(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
          // No "remember me" in the app design: stay logged in until logout.
          'remember': true,
        },
      );
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }

    final body = response.data;
    final data = body is Map ? body['data'] : null;
    final token = data is Map ? data['token'] : null;
    final user = User.fromJson(data is Map ? data['user'] : null);
    if (token is! String || token.isEmpty || user == null) {
      throw const ServerFailure();
    }

    await _sessionStorage.saveSession(token: token, user: user.toJson());
    return user;
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
}
