import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';

// Dropdown options of the signup forms, kept in memory once loaded.

final activityTypesProvider = FutureProvider<List<ReferenceItem>>(
  (ref) => ref.watch(signupRepositoryProvider).getActivityTypes(),
);

final workersCountOptionsProvider = FutureProvider<List<ReferenceItem>>(
  (ref) => ref.watch(signupRepositoryProvider).getWorkersCountOptions(),
);
