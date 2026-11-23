import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/constants/api_constants.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final sessionStorage = ref.watch(sessionStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.timeout,
      sendTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
      headers: const {'Accept': 'application/json', 'Accept-Language': 'ar'},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_isOurBackend(options.uri)) {
          final token = await sessionStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            _isOurBackend(error.requestOptions.uri)) {
          await sessionStorage.clearSession();
        }
        handler.next(error);
      },
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

final Uri _backendUri = Uri.parse(ApiConstants.baseUrl);

// The token must never reach another host, e.g. a full image URL from
// another domain.
bool _isOurBackend(Uri uri) =>
    uri.scheme == 'https' && uri.host == _backendUri.host;
