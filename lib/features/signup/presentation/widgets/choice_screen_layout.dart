import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_top_bar.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Shared layout of the goal and account type screens: title, two option
/// cards and the guest link.
class ChoiceScreenLayout extends StatelessWidget {
  const ChoiceScreenLayout({super.key, required this.options});

  final List<Widget> options;

  // Sizes from the Figma goal and account type frames.
  static const EdgeInsets _topBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenHorizontal,
    11,
    AppSpacing.screenHorizontal,
    0,
  );
  static const EdgeInsets _contentPadding = EdgeInsets.fromLTRB(14, 95, 14, 24);
  static const double _titleToSubtitle = 7;
  static const double _subtitleMaxWidth = 317;
  static const double _subtitleToCards = 69;
  static const double _cardsGap = 24;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: _topBarPadding,
                child: AppTopBar(onBack: () => context.pop()),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: _contentPadding,
                  child: Column(
                    children: [
                      Text(
                        l10n.createAccountTitle,
                        style: AppTextStyles.screenTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: _titleToSubtitle),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _subtitleMaxWidth,
                        ),
                        child: Text(
                          l10n.createAccountSubtitle,
                          style: AppTextStyles.screenSubtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: _subtitleToCards),
                      for (final option in options) ...[
                        option,
                        const SizedBox(height: _cardsGap),
                      ],
                      TextButton(
                        onPressed: () => context.push(AppRoutes.guest),
                        child: Text(
                          l10n.continueAsGuest,
                          style: AppTextStyles.link,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
