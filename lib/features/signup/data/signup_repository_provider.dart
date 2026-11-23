import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/features/signup/data/mock_signup_repository.dart';
import 'package:flutter_sanaa_app/features/signup/domain/signup_repository.dart';

/// Uses a mock signup until the backend sends the mobile app API.
final signupRepositoryProvider = Provider<SignupRepository>(
  (ref) => MockSignupRepository(),
);
