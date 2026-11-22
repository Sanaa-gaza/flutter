import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/dio_failure_mapper.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _withResponse(int statusCode, Object? data) {
  final options = RequestOptions(path: '/auth/login');
  return DioException(
    requestOptions: options,
    response: Response(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  test('no response is a network failure', () {
    final exception = DioException(requestOptions: RequestOptions());
    expect(mapDioException(exception), isA<NetworkFailure>());
  });

  test('401 is unauthorized', () {
    expect(
      mapDioException(_withResponse(401, null)),
      isA<UnauthorizedFailure>(),
    );
  });

  test('field errors accept a list or a plain string', () {
    final failure =
        mapDioException(
              _withResponse(422, {
                'message': 'Invalid data',
                'errors': {
                  'email': ['Email taken', 'Second error'],
                  'phone': 'Phone invalid',
                  'empty': <String>[],
                },
              }),
            )
            as ServerFailure;

    expect(failure.statusCode, 422);
    expect(failure.message, 'Invalid data');
    expect(failure.fieldErrors, {
      'email': 'Email taken',
      'phone': 'Phone invalid',
    });
    expect(failure.requiresVerification, isFalse);
  });

  test('403 with requires_verification asks for verification', () {
    final failure =
        mapDioException(
              _withResponse(403, {
                'message': 'Verify your email',
                'data': {'requires_verification': true},
              }),
            )
            as ServerFailure;

    expect(failure.requiresVerification, isTrue);
  });

  test('a body that is not JSON keeps only the status code', () {
    final failure =
        mapDioException(_withResponse(500, '<html>error</html>'))
            as ServerFailure;

    expect(failure.statusCode, 500);
    expect(failure.message, isNull);
    expect(failure.fieldErrors, isEmpty);
  });
}
