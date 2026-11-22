/// Client-side input checks, copied from the web (`src/utils/validators.js`).
///
/// They only help the user fill the form. The backend runs the same checks
/// and is the real protection.
///
/// Each check returns an error code, or `null` when the value is valid.
/// The screen turns the code into a translated message when it builds, so the
/// text follows the current language.
enum ValidationError {
  fieldRequired,
  emailRequired,
  emailInvalid,
  phoneRequired,
  phoneInvalid,
  passwordRequired,
  passwordWeak,
  confirmPasswordRequired,
  passwordMismatch,
  idNumberRequired,
  idNumberInvalid,
  teamSizeRequired,
  teamSizeInvalid,
  bioRequired,
  bioMinLength,
  termsRequired,
}

/// Which password rules a value meets. Drives the live checklist.
class PasswordRequirements {
  PasswordRequirements(String value)
    : hasLength = value.length >= Validators.passwordMinLength,
      hasLetter = _letter.hasMatch(value),
      hasUppercase = _uppercase.hasMatch(value),
      hasNumber = _number.hasMatch(value),
      hasSpecial = _special.hasMatch(value);

  final bool hasLength;
  final bool hasLetter;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasSpecial;

  bool get meetsAll =>
      hasLength && hasLetter && hasUppercase && hasNumber && hasSpecial;

  static final RegExp _letter = RegExp('[a-zA-Z]');
  static final RegExp _uppercase = RegExp('[A-Z]');
  static final RegExp _number = RegExp('[0-9]');
  static final RegExp _special = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]');
}

abstract final class Validators {
  static const int passwordMinLength = 8;
  static const int bioMinLength = 10;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _phone = RegExp(r'^(59|56)\d{7}$');
  static final RegExp _nationalId = RegExp(r'^\d{9}$');
  static final RegExp _positiveWholeNumber = RegExp(r'^[1-9]\d*$');
  static final RegExp _whitespace = RegExp(r'\s+');

  /// Removes every space from a phone number, before checking and before
  /// sending it.
  static String cleanPhone(String value) =>
      value.trim().replaceAll(_whitespace, '');

  static ValidationError? required(String value) =>
      value.trim().isEmpty ? ValidationError.fieldRequired : null;

  static ValidationError? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ValidationError.emailRequired;
    if (!_email.hasMatch(trimmed)) return ValidationError.emailInvalid;
    return null;
  }

  static ValidationError? phone(String value) {
    final cleaned = cleanPhone(value);
    if (cleaned.isEmpty) return ValidationError.phoneRequired;
    if (!_phone.hasMatch(cleaned)) return ValidationError.phoneInvalid;
    return null;
  }

  // Not trimmed: spaces are valid password characters.
  static ValidationError? password(String value) {
    if (value.isEmpty) return ValidationError.passwordRequired;
    if (!PasswordRequirements(value).meetsAll) {
      return ValidationError.passwordWeak;
    }
    return null;
  }

  static ValidationError? confirmPassword(String value, String password) {
    if (value.isEmpty) return ValidationError.confirmPasswordRequired;
    if (value != password) return ValidationError.passwordMismatch;
    return null;
  }

  static ValidationError? nationalId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ValidationError.idNumberRequired;
    if (!_nationalId.hasMatch(trimmed)) return ValidationError.idNumberInvalid;
    return null;
  }

  static ValidationError? workersCount(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ValidationError.teamSizeRequired;
    if (!_positiveWholeNumber.hasMatch(trimmed)) {
      return ValidationError.teamSizeInvalid;
    }
    return null;
  }

  static ValidationError? bio(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ValidationError.bioRequired;
    if (trimmed.length < bioMinLength) return ValidationError.bioMinLength;
    return null;
  }

  static ValidationError? terms({required bool accepted}) =>
      accepted ? null : ValidationError.termsRequired;
}
