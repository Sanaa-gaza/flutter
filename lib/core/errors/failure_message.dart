import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// One general message for a failure, for screens that show a single error.
String failureMessage(Failure failure, AppLocalizations l10n) =>
    switch (failure) {
      NetworkFailure() => l10n.networkError,
      UnauthorizedFailure(:final message) => message ?? l10n.networkError,
      ServerFailure(:final message, :final fieldErrors) =>
        message ?? fieldErrors.values.firstOrNull ?? l10n.networkError,
    };
