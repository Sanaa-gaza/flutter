import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/reference_data/data/reference_data_repository_impl.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';

// These providers are not auto-disposed, so each list is fetched once and
// then kept in memory. After an error, `ref.invalidate` fetches it again.

final governoratesProvider = FutureProvider<List<ReferenceItem>>(
  (ref) => ref.watch(referenceDataRepositoryProvider).getGovernorates(),
);

final areasProvider = FutureProvider.family<List<ReferenceItem>, int>(
  (ref, governorateId) =>
      ref.watch(referenceDataRepositoryProvider).getAreas(governorateId),
);

final servicesProvider = FutureProvider<List<ReferenceItem>>(
  (ref) => ref.watch(referenceDataRepositoryProvider).getServices(),
);
