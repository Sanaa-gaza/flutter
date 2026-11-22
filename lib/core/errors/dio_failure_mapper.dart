import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';

Failure mapDioException(DioException exception) {
  final response = exception.response;
  if (response == null) return const NetworkFailure();

  final statusCode = response.statusCode;
  if (statusCode == 401) return const UnauthorizedFailure();

  final body = response.data;
  if (body is! Map) return ServerFailure(statusCode: statusCode);

  final message = body['message'];
  return ServerFailure(
    statusCode: statusCode,
    message: message is String && message.isNotEmpty ? message : null,
    fieldErrors: _firstErrorPerField(body['errors']),
    requiresVerification:
        statusCode == 403 && _requiresVerification(body['data']),
  );
}

// Laravel sends a list of messages per field, but a plain string can also
// come back. Keep the first message either way.
Map<String, String> _firstErrorPerField(Object? errors) {
  if (errors is! Map) return const {};

  final result = <String, String>{};
  for (final MapEntry(:key, :value) in errors.entries) {
    if (key is! String) continue;
    final first = value is List && value.isNotEmpty ? value.first : value;
    if (first is String && first.isNotEmpty) result[key] = first;
  }
  return result;
}

bool _requiresVerification(Object? data) =>
    data is Map && data['requires_verification'] == true;
