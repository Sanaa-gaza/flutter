import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';

/// Every method throws a `Failure` on error.
abstract interface class AuthRepository {
  /// Logs in and saves the session. A `ServerFailure` with
  /// `requiresVerification` means the email is not verified yet.
  Future<User> login({required String email, required String password});

  /// The user of the saved session, or null when there is none.
  Future<User?> savedUser();

  /// Ends the session. The token and saved user are always deleted from the
  /// phone, even when the server cannot be reached.
  Future<void> logout();

  /// Checks the 6-digit email code. For [VerificationPurpose.register] the
  /// session is saved before returning.
  Future<VerificationResult> verifyEmail({
    required String email,
    required String code,
    required VerificationPurpose purpose,
  });

  Future<void> resendCode({
    required String email,
    required VerificationPurpose purpose,
  });

  /// Emails a reset code; then the user checks it with [verifyEmail]
  /// (purpose [VerificationPurpose.reset]).
  Future<void> forgotPassword({required String email});

  /// Sets a new password with the token from the reset code.
  Future<void> resetPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}
