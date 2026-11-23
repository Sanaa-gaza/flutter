import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/reference_data/data/mock_reference_data_repository.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_data_repository.dart';

/// Uses sample data until the backend sends the mobile app API. Then switch
/// to `ReferenceDataRepositoryImpl` (adapted to that API).
final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>(
  (ref) => MockReferenceDataRepository(),
);
