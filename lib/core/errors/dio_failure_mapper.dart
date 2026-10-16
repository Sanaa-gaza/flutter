import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';

Failure mapDioException(DioException exception) {
  final response = exception.response;
  if (response == null) return const NetworkFailure();
  if (response.statusCode == 401) return const UnauthorizedFailure();

  final data = response.data;
  if (data is! Map) return const ServerFailure();

  final message = data['message'];
  return ServerFailure(
    message: message is String ? message : null,
    fieldErrors: _firstErrorPerField(data['errors']),
  );
}

Map<String, String> _firstErrorPerField(Object? errors) {
  if (errors is! Map) return const {};

  final result = <String, String>{};
  for (final MapEntry(:key, :value) in errors.entries) {
    if (key is String && value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is String) result[key] = first;
    }
  }
  return result;
}
