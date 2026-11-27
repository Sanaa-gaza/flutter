import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/outlined_app_button.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Temporary home for every role until the role homes are designed (next
/// sprint, including the "account under review" card for craftsmen).
class HomePlaceholderScreen extends ConsumerStatefulWidget {
  const HomePlaceholderScreen({super.key, required this.role});

  final UserRole role;

  @override
  ConsumerState<HomePlaceholderScreen> createState() =>
      _HomePlaceholderScreenState();
}

class _HomePlaceholderScreenState extends ConsumerState<HomePlaceholderScreen> {
  static const double _logoWidth = 102;
  static const double _logoToText = 32;
  static const double _textToButton = 40;

  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await ref.read(authRepositoryProvider).logout();
    if (mounted) context.go(AppRoutes.welcome);
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
        child: SafeArea(
          child: Center(
            child: Padding(
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
                  const SizedBox(height: _logoToText),
                  Text(
                    l10n.homeGreeting(roleName),
                    style: AppTextStyles.screenTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: _textToButton),
                  OutlinedAppButton(
                    label: l10n.logoutButton,
                    onPressed: _isLoggingOut ? null : _logout,
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
