import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Splits a signup failure: errors for fields on the screen go under them,
/// everything else goes to the general alert.
({Map<String, String> fieldErrors, String? general}) splitSignupFailure(
  Failure failure,
  Set<String> screenFieldKeys,
  AppLocalizations l10n,
) {
  switch (failure) {
    case NetworkFailure():
      return (fieldErrors: const {}, general: l10n.networkError);
    case UnauthorizedFailure(:final message):
      return (fieldErrors: const {}, general: message ?? l10n.networkError);
    case ServerFailure(:final message, :final fieldErrors):
      final onScreen = {
        for (final MapEntry(:key, :value) in fieldErrors.entries)
          if (screenFieldKeys.contains(key)) key: value,
      };
      final generalLines = [
        ?message,
        for (final MapEntry(:key, :value) in fieldErrors.entries)
          if (!screenFieldKeys.contains(key)) value,
      ];
      final general = generalLines.isNotEmpty
          ? generalLines.join('\n')
          : onScreen.isEmpty
          ? l10n.networkError
          : null;
      return (fieldErrors: onScreen, general: general);
  }
}
