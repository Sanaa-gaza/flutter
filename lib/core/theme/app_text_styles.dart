import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle onboardingBody = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
  );

  static const TextStyle welcomeMessage = TextStyle(
    fontSize: 18,
    height: 31 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDarker,
  );

  static const TextStyle skip = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle topBarTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle phonePrefix = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryDarker,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
  );

  // A 19px line plus 9px padding above and below gives the 37px field height.
  static const double _fieldLineHeight = 19 / 11;

  static const TextStyle fieldHint = TextStyle(
    fontSize: 11,
    height: _fieldLineHeight,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );

  static const TextStyle fieldInput = TextStyle(
    fontSize: 11,
    height: _fieldLineHeight,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDarker,
  );

  static const TextStyle fieldError = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static const TextStyle uploadLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textUpload,
  );

  static const TextStyle terms = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle termsBold = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle otpDigit = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle stepNumber = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle stepLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle errorAlert = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static const TextStyle small = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
