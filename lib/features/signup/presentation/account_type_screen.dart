import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/goal_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/choice_screen_layout.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/option_card.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Account types for the chosen goal: customer / institution for people who
/// need a service, craftsman / contractor for people who offer one.
class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key, required this.goal});

  final SignupGoal goal;

  // Institution, craftsman and contractor forms come in Tasks 12–14.
  void _openSignupLater() {}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final options = switch (goal) {
      SignupGoal.requestService => [
        OptionCard(
          title: l10n.roleCustomerTitle,
          description: l10n.roleCustomerDescription,
          iconAsset: AppIcons.userProfile,
          iconSize: 18,
          onTap: () => context.push(AppRoutes.customerSignup),
        ),
        OptionCard(
          title: l10n.roleInstitutionTitle,
          description: l10n.roleInstitutionDescription,
          iconAsset: AppIcons.briefcase,
          iconSize: 24,
          onTap: _openSignupLater,
        ),
      ],
      SignupGoal.provideService => [
        OptionCard(
          title: l10n.roleCraftsmanTitle,
          description: l10n.roleCraftsmanDescription,
          iconAsset: AppIcons.wrench,
          iconSize: 24,
          onTap: _openSignupLater,
        ),
        OptionCard(
          title: l10n.roleContractorTitle,
          description: l10n.roleContractorDescription,
          iconAsset: AppIcons.users,
          iconSize: 19,
          onTap: _openSignupLater,
        ),
      ],
    };

    return ChoiceScreenLayout(options: options);
  }
}
