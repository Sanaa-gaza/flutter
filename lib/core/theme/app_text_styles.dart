import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  // Figma's "normal" line height for Cairo (font ascent + descent). Flutter
  // draws Cairo tighter by default, so text sits closer than in the design.
  static const double _normalLineHeight = 1.874;

  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 30,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle onboardingBody = TextStyle(
    fontSize: 18,
    height: _normalLineHeight,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
  );

  static const TextStyle welcomeMessage = TextStyle(
    fontSize: 18,
    height: 31 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDarker,
  );

  static const TextStyle screenSubtitle = TextStyle(
    fontSize: 14,
    height: _normalLineHeight,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
  );

  static const TextStyle optionTitle = TextStyle(
    fontSize: 16,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle optionDescription = TextStyle(
    fontSize: 12,
    height: 16.4 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
  );

  static const TextStyle skip = TextStyle(
    fontSize: 10,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle topBarTitle = TextStyle(
    fontSize: 17,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle button = TextStyle(
    fontSize: 20,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: _normalLineHeight,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    height: _normalLineHeight,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle phonePrefix = TextStyle(
    fontSize: 12,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 12,
    height: _normalLineHeight,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryDarker,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 11,
    height: _normalLineHeight,
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
    height: _normalLineHeight,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static const TextStyle uploadLabel = TextStyle(
    fontSize: 10,
    height: _normalLineHeight,
    fontWeight: FontWeight.w400,
    color: AppColors.textUpload,
  );

  static const TextStyle terms = TextStyle(
    fontSize: 11,
    height: _normalLineHeight,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle termsBold = TextStyle(
    fontSize: 11,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle otpDigit = TextStyle(
    fontSize: 20,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDarker,
  );

  static const TextStyle stepNumber = TextStyle(
    fontSize: 13,
    height: _normalLineHeight,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle stepLabel = TextStyle(
    fontSize: 11,
    height: _normalLineHeight,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle errorAlert = TextStyle(
    fontSize: 12,
    height: _normalLineHeight,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static const TextStyle small = TextStyle(
    fontSize: 10,
    height: _normalLineHeight,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
