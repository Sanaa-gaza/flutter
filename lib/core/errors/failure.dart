sealed class Failure {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
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
