import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/widgets/app_form_card.dart';
import 'package:flutter_sanaa_app/core/widgets/app_top_bar.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:go_router/go_router.dart';

/// Frame of the signup forms: top bar with a title and back arrow, an
/// optional [header] (the step indicator), and a white card that scrolls
/// with the keyboard.
class SignupFormScaffold extends StatelessWidget {
  const SignupFormScaffold({
    super.key,
    required this.title,
    required this.child,
    this.header,
  });

  final String title;
  final Widget child;
  final Widget? header;

  // Sizes from the Figma signup frames.
  static const EdgeInsets _topBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenHorizontal,
    14,
    AppSpacing.screenHorizontal,
    0,
  );
  static const EdgeInsets _cardMargin = EdgeInsets.fromLTRB(25, 44, 25, 24);
  static const EdgeInsets _withHeaderMargin = EdgeInsets.fromLTRB(
    25,
    22,
    25,
    24,
  );
  static const double _headerToCard = 17;
  static const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(16, 37, 16, 18);

  @override
  Widget build(BuildContext context) {
    final header = this.header;
    final card = AppFormCard(padding: _cardPadding, child: child);

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
                  padding: header == null ? _cardMargin : _withHeaderMargin,
                  child: header == null
                      ? card
                      : Column(
                          children: [
                            header,
                            const SizedBox(height: _headerToCard),
                            card,
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
