import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_form_card.dart';
import 'package:flutter_sanaa_app/core/widgets/app_top_bar.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Shared layout of the login, forgot password, code and new password
/// screens: back arrow, logo, title, short text, a white card and an
/// optional footer.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.card,
    this.subtitleToCard = 34,
    this.footer,
  });

  final String title;

  /// Usually a [Text]; the login screen adds a link inside it.
  final Widget subtitle;
  final VoidCallback onBack;
  final Widget card;
  final double subtitleToCard;
  final Widget? footer;

  // Sizes from the Figma auth frames.
  static const EdgeInsets _topBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenHorizontal,
    14,
    AppSpacing.screenHorizontal,
    0,
  );
  static const EdgeInsets _contentPadding = EdgeInsets.fromLTRB(24, 19, 25, 24);
  static const EdgeInsets _cardPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 26,
  );
  static const double _logoWidth = 109;
  static const double _titleToSubtitle = 3;
  static const double _subtitleMaxWidth = 260;

  @override
  Widget build(BuildContext context) {
    final footer = this.footer;

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: _topBarPadding,
                child: AppTopBar(onBack: onBack),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: _contentPadding,
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.logoMark,
                        width: _logoWidth,
                        semanticLabel: AppLocalizations.of(context).appTitle,
                      ),
                      const SizedBox(height: AppSpacing.logoToTitle),
                      Text(
                        title,
                        style: AppTextStyles.screenTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: _titleToSubtitle),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _subtitleMaxWidth,
                        ),
                        child: subtitle,
                      ),
                      SizedBox(height: subtitleToCard),
                      AppFormCard(padding: _cardPadding, child: card),
                      ?footer,
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
