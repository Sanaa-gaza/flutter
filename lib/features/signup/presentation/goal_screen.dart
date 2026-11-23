import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/choice_screen_layout.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/option_card.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// What the user wants from the app. It decides which account types show next.
enum SignupGoal { requestService, provideService }

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ChoiceScreenLayout(
      options: [
        OptionCard(
          title: l10n.goalRequestTitle,
          description: l10n.goalRequestDescription,
          iconAsset: AppIcons.wrench,
          iconSize: 24,
          onTap: () =>
              context.push(AppRoutes.accountType(SignupGoal.requestService)),
        ),
        OptionCard(
          title: l10n.goalProvideTitle,
          description: l10n.goalProvideDescription,
          iconAsset: AppIcons.search,
          iconSize: 26,
          onTap: () =>
              context.push(AppRoutes.accountType(SignupGoal.provideService)),
        ),
      ],
    );
  }
}
