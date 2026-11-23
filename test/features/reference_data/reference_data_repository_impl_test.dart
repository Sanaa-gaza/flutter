import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/features/reference_data/data/reference_data_repository_impl.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers every request with a fixed status and JSON body, without network.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object body;
  String? lastPath;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastPath = options.path;
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ReferenceDataRepositoryImpl _repository(_FakeAdapter adapter) =>
    ReferenceDataRepositoryImpl(
      Dio(BaseOptions(baseUrl: 'https://example.test/api'))
        ..httpClientAdapter = adapter,
    );

void main() {
  test('parses the list and skips broken items', () async {
    final adapter = _FakeAdapter(200, {
      'success': true,
      'data': [
        {'id': 2, 'name': 'غزة'},
        {'id': '3', 'name': 'id is not a number'},
        {'id': 4},
        'not an object',
        {'id': 5, 'name': 'رفح'},
      ],
    });

    final items = await _repository(adapter).getGovernorates();

    expect(adapter.lastPath, '/governorates');
    expect(items, const [
      ReferenceItem(id: 2, name: 'غزة'),
      ReferenceItem(id: 5, name: 'رفح'),
    ]);
  });

  test('areas use the governorate id in the path', () async {
    final adapter = _FakeAdapter(200, {'data': <Object>[]});

    await _repository(adapter).getAreas(2);

    expect(adapter.lastPath, '/governorates/2/areas');
  });

  test('a server error becomes a ServerFailure with its message', () async {
    final adapter = _FakeAdapter(404, {
      'success': false,
      'message': 'المحافظة غير موجودة.',
      'errors': <Object>[],
    });

    await expectLater(
      _repository(adapter).getAreas(999),
      throwsA(
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'المحافظة غير موجودة.',
        ),
      ),
    );
  });

  test('a body without a data list is a ServerFailure', () async {
    final adapter = _FakeAdapter(200, {'success': true});

    await expectLater(
      _repository(adapter).getServices(),
      throwsA(isA<ServerFailure>()),
    );
  });
}
