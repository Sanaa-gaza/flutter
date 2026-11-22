import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

extension ValidationErrorText on ValidationError {
  String message(AppLocalizations l10n) => switch (this) {
    ValidationError.fieldRequired => l10n.fieldRequired,
    ValidationError.emailRequired => l10n.emailRequired,
    ValidationError.emailInvalid => l10n.emailInvalid,
    ValidationError.phoneRequired => l10n.phoneRequired,
    ValidationError.phoneInvalid => l10n.phoneInvalid,
    ValidationError.passwordRequired => l10n.passwordRequired,
    ValidationError.passwordWeak => l10n.passwordWeak,
    ValidationError.confirmPasswordRequired => l10n.confirmPasswordRequired,
    ValidationError.passwordMismatch => l10n.passwordMismatch,
    ValidationError.idNumberRequired => l10n.idNumberRequired,
    ValidationError.idNumberInvalid => l10n.idNumberInvalid,
    ValidationError.teamSizeRequired => l10n.teamSizeRequired,
    ValidationError.teamSizeInvalid => l10n.teamSizeInvalid,
    ValidationError.bioRequired => l10n.bioRequired,
    ValidationError.bioMinLength => l10n.bioMinLength,
    ValidationError.termsRequired => l10n.termsRequired,
  };
}
