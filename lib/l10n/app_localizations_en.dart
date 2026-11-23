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
  String get emailInvalid => 'Please enter a valid email address';

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

  @override
  String get backButton => 'Back';

  @override
  String get craftsmanSignupTitle => 'Create a craftsman account';

  @override
  String get otpLabel => 'Confirm your email';

  @override
  String get networkError =>
      'Could not reach the server. Check your internet connection and try again.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingTitle1 => 'Welcome to Sanaa';

  @override
  String get onboardingBody1 => 'Find every craftsman you need in one place';

  @override
  String get onboardingTitle2 => 'Trust without asking!';

  @override
  String get onboardingBody2 =>
      'Browse real reviews from past customers and see a full profile for every craftsman';

  @override
  String get onboardingTitle3 => 'Start your journey now!';

  @override
  String get onboardingBody3 =>
      'Book and talk to the right craftsman in a few simple steps, and get your tasks done fast and with confidence.';

  @override
  String get welcomeMessage =>
      'Welcome to Sanaa. Log in or create an account now';

  @override
  String get createAccountButton => 'Create an account';

  @override
  String get continueAsGuest => 'Continue now and sign up later';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountSubtitle =>
      'How do you want to use Sanaa? Pick what suits you and we will guide you step by step.';

  @override
  String get goalRequestTitle => 'I need a service';

  @override
  String get goalRequestDescription =>
      'Find a trusted craftsman, or post a request or tender and receive offers.';

  @override
  String get goalProvideTitle => 'I offer a service';

  @override
  String get goalProvideDescription =>
      'Receive customer requests, send your offers, and get new work opportunities';

  @override
  String get roleCustomerTitle => 'Customer';

  @override
  String get roleCustomerDescription =>
      'Find the right craftsman for the service I need\nMaintenance, installation, finishing.';

  @override
  String get roleInstitutionTitle => 'Institution';

  @override
  String get roleInstitutionDescription =>
      'Browse categories and contractors and find the right craftsman for your projects';

  @override
  String get roleCraftsmanTitle => 'Craftsman';

  @override
  String get roleCraftsmanDescription =>
      'Offer services, manage work requests, and grow your business on our platform';

  @override
  String get roleContractorTitle => 'Contractor';

  @override
  String get roleContractorDescription =>
      'Browse services, categories and craftsmen to find the right professional for your needs';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid =>
      'Please enter a valid mobile number starting with 59 or 56';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordWeak =>
      'Password must be at least 8 characters and include an uppercase letter, a number, and a special character';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get idNumberRequired => 'Please enter the ID number';

  @override
  String get idNumberInvalid => 'ID number must be exactly 9 digits';

  @override
  String get teamSizeRequired => 'Please enter the number of workers';

  @override
  String get teamSizeInvalid => 'Please enter a whole number greater than zero';

  @override
  String get bioRequired => 'Please write a bio about yourself';

  @override
  String get bioMinLength => 'Bio must be at least 10 characters';

  @override
  String get termsRequired => 'Please agree to the terms and conditions';
}
