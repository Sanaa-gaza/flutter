import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The app name shown in the app bar and the OS task switcher
  ///
  /// In ar, this message translates to:
  /// **'صنعة'**
  String get appTitle;

  /// Submit button on the login screen
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// Label above the email field
  ///
  /// In ar, this message translates to:
  /// **'البريد الالكتروني'**
  String get emailLabel;

  /// Placeholder inside the email field
  ///
  /// In ar, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// Validation error when the email format is wrong
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صحيح'**
  String get emailInvalid;

  /// Label above the password field
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// Placeholder inside the password field
  ///
  /// In ar, this message translates to:
  /// **'قم بإنشاء كلمة مرور قوية تحتوي على أرقام ورموز'**
  String get passwordHint;

  /// Screen reader label for the eye icon when the password is hidden
  ///
  /// In ar, this message translates to:
  /// **'إظهار كلمة المرور'**
  String get showPassword;

  /// Screen reader label for the eye icon when the password is visible
  ///
  /// In ar, this message translates to:
  /// **'إخفاء كلمة المرور'**
  String get hidePassword;

  /// Label above the phone number field
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneLabel;

  /// Placeholder inside the phone number field
  ///
  /// In ar, this message translates to:
  /// **'ادخل رقم جوال بمقدمة تبدأ 59 56'**
  String get phoneHint;

  /// Label above the governorate dropdown
  ///
  /// In ar, this message translates to:
  /// **'المحافظة'**
  String get governorateLabel;

  /// Placeholder inside the governorate dropdown
  ///
  /// In ar, this message translates to:
  /// **'اختر المحافظة'**
  String get governorateHint;

  /// Label above the craftsman bio field
  ///
  /// In ar, this message translates to:
  /// **'نبذة عني'**
  String get bioLabel;

  /// Placeholder inside the craftsman bio field
  ///
  /// In ar, this message translates to:
  /// **'تحدث عن خبرتك ومهاراتك'**
  String get bioHint;

  /// Text inside the image upload box
  ///
  /// In ar, this message translates to:
  /// **'أنقر أو أسحب صورة'**
  String get uploadImageLabel;

  /// First part of the terms checkbox text, followed by termsAndConditions
  ///
  /// In ar, this message translates to:
  /// **'أوافق على '**
  String get termsAgree;

  /// Bold part of the terms checkbox text
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get termsAndConditions;

  /// Step indicator label for the personal info step
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get stepPersonalInfo;

  /// Step indicator label for the craftsman details step
  ///
  /// In ar, this message translates to:
  /// **'بيانات الحرفي'**
  String get stepCraftsmanInfo;

  /// Screen reader label for the back arrow in the top bar
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get backButton;

  /// Top bar title on the craftsman signup screens
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب كحرفي'**
  String get craftsmanSignupTitle;

  /// Label above the six verification code boxes
  ///
  /// In ar, this message translates to:
  /// **'تأكيد البريد الإلكتروني'**
  String get otpLabel;

  /// General alert when the request gets no response from the server
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الاتصال بالخادم. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.'**
  String get networkError;

  /// Small button on the onboarding pages that jumps to the welcome screen
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get onboardingSkip;

  /// Button that goes to the next onboarding page
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get onboardingNext;

  /// Button on the last onboarding page
  ///
  /// In ar, this message translates to:
  /// **'ابدأ معنا'**
  String get onboardingStart;

  /// Title of onboarding page 1
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في صنعة'**
  String get onboardingTitle1;

  /// Text of onboarding page 1
  ///
  /// In ar, this message translates to:
  /// **'اعثر على كل الحرفيين الذين تحتاجهم في مكان واحد'**
  String get onboardingBody1;

  /// Title of onboarding page 2
  ///
  /// In ar, this message translates to:
  /// **'ثقة بلا سؤال!'**
  String get onboardingTitle2;

  /// Text of onboarding page 2
  ///
  /// In ar, this message translates to:
  /// **'تصفّح تقييمات حقيقية من عملاء سابقين اطّلع على ملف كامل لكل حرفي'**
  String get onboardingBody2;

  /// Title of onboarding page 3
  ///
  /// In ar, this message translates to:
  /// **'ابدأ رحلتك الآن!'**
  String get onboardingTitle3;

  /// Text of onboarding page 3
  ///
  /// In ar, this message translates to:
  /// **'احجز وتواصل مع الحرفي المناسب بخطوات بسيطة، أنجز مهامك بسرعة وثقة.'**
  String get onboardingBody3;

  /// Text under the logo on the welcome screen
  ///
  /// In ar, this message translates to:
  /// **'مرحبًا بك في تطبيق صنعة، سجّل دخولك أو أنشئ حسابًا الآن'**
  String get welcomeMessage;

  /// Welcome screen button that starts signup
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get createAccountButton;

  /// Link that opens the app as a guest without an account
  ///
  /// In ar, this message translates to:
  /// **'الدخول الآن والتسجيل لاحقاً'**
  String get continueAsGuest;

  /// Title of the goal and account type screens
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك'**
  String get createAccountTitle;

  /// Text under the title on the goal and account type screens
  ///
  /// In ar, this message translates to:
  /// **'كيف بدك تستخدم صنعة؟ اختر الطريقة اللي بتناسبك وبنكمّل معك خطوة بخطوة.'**
  String get createAccountSubtitle;

  /// Goal card for people who need a service
  ///
  /// In ar, this message translates to:
  /// **'بدي أطلب خدمة'**
  String get goalRequestTitle;

  /// Description of the request a service goal card
  ///
  /// In ar, this message translates to:
  /// **'دوّر على حرفي موثوق، أو انشر طلب أو مناقصة واستقبل عروض.'**
  String get goalRequestDescription;

  /// Goal card for people who offer a service
  ///
  /// In ar, this message translates to:
  /// **'بدي أقدم خدمة'**
  String get goalProvideTitle;

  /// Description of the provide a service goal card
  ///
  /// In ar, this message translates to:
  /// **'استقبل طلبات العملاء، قدّم عروضك، واحصل على فرص عمل جديدة'**
  String get goalProvideDescription;

  /// Account type card for the customer role
  ///
  /// In ar, this message translates to:
  /// **'عميل'**
  String get roleCustomerTitle;

  /// Description of the customer account type card
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن حرفي مناسب لتنفيذ الخدمة التي أحتاجها\nصيانة، تركيب، تشطيب.'**
  String get roleCustomerDescription;

  /// Account type card for the institution role
  ///
  /// In ar, this message translates to:
  /// **'مؤسسة'**
  String get roleInstitutionTitle;

  /// Description of the institution account type card
  ///
  /// In ar, this message translates to:
  /// **'تصفح الفئات والمقاولين واعثر على الحرفي المناسب لتنفيذ مشاريعك'**
  String get roleInstitutionDescription;

  /// Account type card for the craftsman role
  ///
  /// In ar, this message translates to:
  /// **'حرفي'**
  String get roleCraftsmanTitle;

  /// Description of the craftsman account type card
  ///
  /// In ar, this message translates to:
  /// **'قَدّم الخدمات، وإدارة الطلبات المهنية، ونمّ أعمالك عبر منصتنا'**
  String get roleCraftsmanDescription;

  /// Account type card for the contractor role
  ///
  /// In ar, this message translates to:
  /// **'مقاول'**
  String get roleContractorTitle;

  /// Description of the contractor account type card
  ///
  /// In ar, this message translates to:
  /// **'تصفح الخدمات، والفئات، والحرفيين للعثور على المحترف المناسب لاحتياجاتك'**
  String get roleContractorDescription;

  /// Top bar title on the customer signup screen
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب عميل'**
  String get customerSignupTitle;

  /// Label above the full name field
  ///
  /// In ar, this message translates to:
  /// **'الاسم بالكامل'**
  String get fullNameLabel;

  /// Placeholder inside the full name field
  ///
  /// In ar, this message translates to:
  /// **'ادخل اسمك بالكامل'**
  String get fullNameHint;

  /// Label above the confirm password field
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPasswordLabel;

  /// Placeholder inside the confirm password field
  ///
  /// In ar, this message translates to:
  /// **'قم بإدخال كلمة المرور مرة أخرى'**
  String get confirmPasswordHint;

  /// Label above the home address field
  ///
  /// In ar, this message translates to:
  /// **'عنوان السكن'**
  String get addressLabel;

  /// Placeholder inside the home address field
  ///
  /// In ar, this message translates to:
  /// **'الشارع، المنطقة'**
  String get addressHint;

  /// Submit button that moves to the next step of a form
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get nextButton;

  /// Dropdown placeholder while its options load
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loadingOptions;

  /// Error under a dropdown when its options fail to load
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل القائمة، حاول مرة أخرى.'**
  String get optionsLoadError;

  /// Validation error when the full name is empty
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الاسم بالكامل'**
  String get fullNameRequired;

  /// Validation error when no governorate is chosen
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار المحافظة'**
  String get governorateRequired;

  /// Validation error when the home address is empty
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال عنوان السكن'**
  String get addressRequired;

  /// Title of the code screen after signup
  ///
  /// In ar, this message translates to:
  /// **'تأكيد البريد الإلكتروني'**
  String get verifyEmailTitle;

  /// Text under the title of the code screen after signup
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المكوّن من 6 أرقام المرسل إلى بريدك الإلكتروني'**
  String get verifyEmailSubtitle;

  /// Title of the forgot password screens
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور'**
  String get forgotPasswordTitle;

  /// Text under the title of the code screen for a password reset
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز الذي أرسلناه إلى بريدك الإلكتروني المرتبط بحسابك لإعادة تعيين كلمة المرور'**
  String get resetCodeSubtitle;

  /// Button that checks the email code
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الرمز'**
  String get confirmCodeButton;

  /// Text before the resend link on the code screen
  ///
  /// In ar, this message translates to:
  /// **'لم تتلقَّ أي رمز؟ '**
  String get codeNotReceived;

  /// Link that sends a new email code
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال'**
  String get resendCode;

  /// Error when the code has fewer than 6 digits
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الرمز المكوّن من 6 أرقام'**
  String get codeRequired;

  /// Message after a new code was sent
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمزاً جديداً إلى بريدك الإلكتروني'**
  String get codeResent;

  /// Temporary home text after login, until the role homes are built
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل دخولك كـ {role}'**
  String signedInAs(String role);

  /// Text under the login title, before the bold create account link
  ///
  /// In ar, this message translates to:
  /// **'لا تمتلك حساب؟ الرجوع إلى '**
  String get loginNoAccountPrefix;

  /// Text at the bottom of the login screen, before the create account link
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟ '**
  String get loginNoAccount;

  /// Placeholder inside the password field on the login screen
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور'**
  String get loginPasswordHint;

  /// Link under the password field on the login screen
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPasswordLink;

  /// Submit button on the login screen, as written in the design
  ///
  /// In ar, this message translates to:
  /// **'إرسال الكود'**
  String get sendCodeButton;

  /// Validation error for an empty required field
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// Validation error when the email is empty
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مطلوب'**
  String get emailRequired;

  /// Validation error when the phone number is empty
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف مطلوب'**
  String get phoneRequired;

  /// Validation error when the phone number is not 9 digits starting with 59 or 56
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم جوال صحيح يبدأ بـ 59 أو 56'**
  String get phoneInvalid;

  /// Validation error when the password is empty
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور مطلوبة'**
  String get passwordRequired;

  /// Validation error when the password misses a strength rule
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، حرف إنجليزي كبير، رقم، ورمز خاص'**
  String get passwordWeak;

  /// Validation error when the confirm password field is empty
  ///
  /// In ar, this message translates to:
  /// **'يرجى تأكيد كلمة المرور'**
  String get confirmPasswordRequired;

  /// Validation error when the two passwords differ
  ///
  /// In ar, this message translates to:
  /// **'كلمتا المرور غير متطابقتين'**
  String get passwordMismatch;

  /// Validation error when the contractor national ID is empty
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم الهوية'**
  String get idNumberRequired;

  /// Validation error when the national ID is not exactly 9 digits
  ///
  /// In ar, this message translates to:
  /// **'رقم الهوية يجب أن يتكون من 9 أرقام'**
  String get idNumberInvalid;

  /// Validation error when the contractor workers count is empty
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال عدد العمال'**
  String get teamSizeRequired;

  /// Validation error when the workers count is not a whole number above zero
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال عدد صحيح أكبر من صفر'**
  String get teamSizeInvalid;

  /// Validation error when the craftsman bio is empty
  ///
  /// In ar, this message translates to:
  /// **'يرجى كتابة نبذة عنك'**
  String get bioRequired;

  /// Validation error when the bio is shorter than 10 characters
  ///
  /// In ar, this message translates to:
  /// **'يجب أن لا تقل النبذة عن 10 أحرف'**
  String get bioMinLength;

  /// Validation error when the terms checkbox is not checked
  ///
  /// In ar, this message translates to:
  /// **'يرجى الموافقة على الشروط والاحكام'**
  String get termsRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
