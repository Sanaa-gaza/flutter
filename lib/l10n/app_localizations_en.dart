// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sanaa';

  @override
  String get loginButton => 'Log in';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint =>
      'Create a strong password with numbers and symbols';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => 'Mobile number starting with 59 or 56';

  @override
  String get governorateLabel => 'Governorate';

  @override
  String get governorateHint => 'Choose a governorate';

  @override
  String get bioLabel => 'About me';

  @override
  String get bioHint => 'Tell us about your experience and skills';

  @override
  String get uploadImageLabel => 'Tap or drag an image';

  @override
  String get termsAgree => 'I agree to the ';

  @override
  String get termsAndConditions => 'terms and conditions';

  @override
  String get stepPersonalInfo => 'Personal info';

  @override
  String get stepCraftsmanInfo => 'Craftsman details';
}
