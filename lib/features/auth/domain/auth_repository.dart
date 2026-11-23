import 'package:flutter_sanaa_app/features/auth/domain/user.dart';

abstract interface class AuthRepository {
  /// Logs in and saves the session. Throws a `Failure` on error; a
  /// `ServerFailure` with `requiresVerification` means the email is not
  /// verified yet.
  Future<User> login({required String email, required String password});

  /// The user of the saved session, or null when there is none.
  Future<User?> savedUser();
}
