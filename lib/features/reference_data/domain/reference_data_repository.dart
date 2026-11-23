import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';

/// Every method throws a `Failure` when the request fails.
abstract interface class ReferenceDataRepository {
  Future<List<ReferenceItem>> getGovernorates();

  Future<List<ReferenceItem>> getAreas(int governorateId);

  Future<List<ReferenceItem>> getServices();
}
