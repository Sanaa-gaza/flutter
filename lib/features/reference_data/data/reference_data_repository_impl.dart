import 'package:dio/dio.dart';
import 'package:flutter_sanaa_app/core/errors/dio_failure_mapper.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_data_repository.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';

class ReferenceDataRepositoryImpl implements ReferenceDataRepository {
  ReferenceDataRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ReferenceItem>> getGovernorates() => _getList('/governorates');

  @override
  Future<List<ReferenceItem>> getAreas(int governorateId) =>
      _getList('/governorates/$governorateId/areas');

  @override
  Future<List<ReferenceItem>> getServices() => _getList('/services');

  Future<List<ReferenceItem>> _getList(String path) async {
    final Response<Object?> response;
    try {
      response = await _dio.get<Object?>(path);
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }

    final body = response.data;
    final data = body is Map ? body['data'] : null;
    if (data is! List) throw const ServerFailure();
    return [for (final item in data) ?_parseItem(item)];
  }

  // Items with a missing or wrong id or name are skipped instead of crashing.
  static ReferenceItem? _parseItem(Object? item) {
    if (item is! Map) return null;
    final id = item['id'];
    final name = item['name'];
    if (id is! int || name is! String || name.isEmpty) return null;
    return ReferenceItem(id: id, name: name);
  }
}
