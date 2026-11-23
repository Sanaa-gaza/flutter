sealed class Failure {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// 401: the session ended, or the login email or password is wrong.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({this.message});

  final String? message;
}

final class ServerFailure extends Failure {
  const ServerFailure({
    this.statusCode,
    this.message,
    this.fieldErrors = const {},
    this.requiresVerification = false,
  });

  final int? statusCode;
  final String? message;
  final Map<String, String> fieldErrors;

  /// Login answered 403 because the email is not verified yet: the app opens
  /// the verification screen instead of showing an error.
  final bool requiresVerification;
}
