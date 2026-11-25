import 'package:flutter_sanaa_app/features/auth/domain/user.dart';

/// Why the user enters an email code.
enum VerificationPurpose {
  register('register'),
  reset('reset');

  const VerificationPurpose(this.apiName);

  final String apiName;
}

sealed class VerificationResult {
  const VerificationResult();
}

/// After signup: the account is verified and the session is saved.
final class VerifiedSession extends VerificationResult {
  const VerifiedSession(this.user);

  final User user;
}

/// After "forgot password": a short-lived token for the reset screen.
/// It stays in memory only and is not a login token.
final class ResetAllowed extends VerificationResult {
  const ResetAllowed(this.resetToken);

  final String resetToken;
}
