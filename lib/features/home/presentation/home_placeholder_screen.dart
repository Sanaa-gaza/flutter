import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Shown after signing in until the role homes are built (Task 15),
/// including the "account under review" card for craftsmen.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key, required this.role});

  final UserRole role;

  static const double _logoWidth = 102;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: Center(
          child: Image.asset(
            AppImages.logo,
            width: _logoWidth,
            semanticLabel: AppLocalizations.of(context).appTitle,
          ),
        ),
      ),
    );
  }
}
