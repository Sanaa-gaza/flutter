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
  const ServerFailure({this.message, this.fieldErrors = const {}});

  final String? message;
  final Map<String, String> fieldErrors;
}
