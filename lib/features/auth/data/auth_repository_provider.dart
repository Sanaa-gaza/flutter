import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/network/session_storage.dart';
import 'package:flutter_sanaa_app/features/auth/data/mock_auth_repository.dart';
import 'package:flutter_sanaa_app/features/auth/domain/auth_repository.dart';

/// Uses a mock login until the backend sends the mobile app API. Then switch
/// to `AuthRepositoryImpl` (adapted to that API).
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(ref.watch(sessionStorageProvider)),
);
