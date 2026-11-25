import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Shown after signing in, until the role homes are built (Task 15):
/// a green check with the role for a moment, then the logo.
class HomePlaceholderScreen extends StatefulWidget {
  const HomePlaceholderScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<HomePlaceholderScreen> createState() => _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState extends State<HomePlaceholderScreen> {
  static const Duration _successDuration = Duration(milliseconds: 1500);
  static const Duration _fadeDuration = Duration(milliseconds: 400);
  static const double _checkCircleSize = 72;
  static const double _checkIconSize = 44;
  static const double _checkToText = 16;
  static const double _logoWidth = 102;

  late final Timer _timer;
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_successDuration, () => setState(() => _showLogo = true));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final roleName = switch (widget.role) {
      UserRole.customer || UserRole.admin => l10n.roleCustomerTitle,
      UserRole.craftsman => l10n.roleCraftsmanTitle,
      UserRole.institution => l10n.roleInstitutionTitle,
      UserRole.contractor => l10n.roleContractorTitle,
    };

    return Scaffold(
      body: PatternBackground(
        child: Center(
          child: AnimatedSwitcher(
            duration: _fadeDuration,
            child: _showLogo
                ? Image.asset(
                    AppImages.logo,
                    key: const ValueKey('logo'),
                    width: _logoWidth,
                    semanticLabel: l10n.appTitle,
                  )
                : Semantics(
                    key: const ValueKey('success'),
                    liveRegion: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: _checkCircleSize,
                          height: _checkCircleSize,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: _checkIconSize,
                          ),
                        ),
                        const SizedBox(height: _checkToText),
                        Text(
                          l10n.signedInAs(roleName),
                          style: AppTextStyles.screenTitle,
                          textAlign: TextAlign.center,
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
