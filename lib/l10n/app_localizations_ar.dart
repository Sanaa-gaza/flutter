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

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'قم بإنشاء كلمة مرور قوية تحتوي على أرقام ورموز';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => 'ادخل رقم جوال بمقدمة تبدأ 59 56';

  @override
  String get governorateLabel => 'المحافظة';

  @override
  String get governorateHint => 'اختر المحافظة';

  @override
  String get bioLabel => 'نبذة عني';

  @override
  String get bioHint => 'تحدث عن خبرتك ومهاراتك';

  @override
  String get uploadImageLabel => 'أنقر أو أسحب صورة';

  @override
  String get termsAgree => 'أوافق على ';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get stepPersonalInfo => 'المعلومات الشخصية';

  @override
  String get stepCraftsmanInfo => 'بيانات الحرفي';
}
