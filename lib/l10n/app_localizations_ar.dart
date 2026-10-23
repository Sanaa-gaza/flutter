// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'صنعة';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get emailLabel => 'البريد الالكتروني';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get emailInvalid => 'البريد الإلكتروني غير صحيح';
}
