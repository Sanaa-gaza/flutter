import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/widgets/app_top_bar.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:go_router/go_router.dart';

/// Frame of the signup forms: top bar with a title and back arrow, and a
/// white card that scrolls with the keyboard.
class SignupFormScaffold extends StatelessWidget {
  const SignupFormScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  // Sizes from the Figma signup frames.
  static const EdgeInsets _topBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenHorizontal,
    14,
    AppSpacing.screenHorizontal,
    0,
  );
  static const EdgeInsets _cardMargin = EdgeInsets.fromLTRB(25, 44, 25, 24);
  static const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(16, 37, 16, 18);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.card);

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: _topBarPadding,
                child: AppTopBar(title: title, onBack: () => context.pop()),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: _cardMargin,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.formCardShadow,
                          offset: Offset(0, 8),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Padding(padding: _cardPadding, child: child),
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
