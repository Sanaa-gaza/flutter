import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/outlined_app_button.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Temporary home for a visitor without an account. It makes no request
/// that needs a login token.
class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  static const double _logoWidth = 102;
  static const double _logoToTitle = 32;
  static const double _titleToMessage = 8;
  static const double _messageToButtons = 40;
  static const double _buttonsGap = 17;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.logo,
                    width: _logoWidth,
                    semanticLabel: l10n.appTitle,
                  ),
                  const SizedBox(height: _logoToTitle),
                  Text(
                    l10n.guestGreeting,
                    style: AppTextStyles.screenTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _titleToMessage),
                  Text(
                    l10n.guestMessage,
                    style: AppTextStyles.screenSubtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _messageToButtons),
                  PrimaryButton(
                    label: l10n.createAccountButton,
                    height: AppSizes.buttonHeightLarge,
                    onPressed: () => context.push(AppRoutes.goal),
                  ),
                  const SizedBox(height: _buttonsGap),
                  OutlinedAppButton(
                    label: l10n.loginButton,
                    height: AppSizes.buttonHeightLarge,
                    onPressed: () => context.push(AppRoutes.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
