import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_top_bar.dart';
import 'package:flutter_sanaa_app/core/widgets/outlined_app_button.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Sizes from the Figma welcome frame.
  static const EdgeInsets _topBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenHorizontal,
    11,
    AppSpacing.screenHorizontal,
    0,
  );
  // Figma places the content a little above the vertical center.
  static const Alignment _contentAlignment = Alignment(0, -0.12);
  static const double _logoWidth = 109;
  static const double _messageMaxWidth = 319;
  static const double _messageToButtons = 61;
  static const double _buttonsGap = 17;
  static const double _buttonsHorizontal = 31;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: _contentAlignment,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _buttonsHorizontal,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppImages.logoMark,
                        width: _logoWidth,
                        semanticLabel: l10n.appTitle,
                      ),
                      const SizedBox(height: AppSpacing.logoToTitle),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _messageMaxWidth,
                        ),
                        child: Text(
                          l10n.welcomeMessage,
                          style: AppTextStyles.welcomeMessage,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: _messageToButtons),
                      PrimaryButton(
                        label: l10n.createAccountButton,
                        height: AppSizes.buttonHeightLarge,
                        // Opens the goal screen in Task 8.
                        onPressed: () {},
                      ),
                      const SizedBox(height: _buttonsGap),
                      OutlinedAppButton(
                        label: l10n.loginButton,
                        height: AppSizes.buttonHeightLarge,
                        // Opens the login screen in Task 7.
                        onPressed: () {},
                      ),
                      const SizedBox(height: _buttonsGap),
                      TextButton(
                        // Opens the guest home in Task 15.
                        onPressed: () {},
                        child: Text(
                          l10n.continueAsGuest,
                          style: AppTextStyles.link,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: _topBarPadding,
                child: AppTopBar(
                  onBack: () => context.go(AppRoutes.onboarding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
