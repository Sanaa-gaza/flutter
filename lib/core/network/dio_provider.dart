import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.timeout,
      sendTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
      headers: const {
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      },
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
