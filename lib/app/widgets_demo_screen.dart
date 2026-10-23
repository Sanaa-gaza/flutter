import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/outlined_app_button.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

class WidgetsDemoScreen extends StatelessWidget {
  const WidgetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          children: [
            Text(
              l10n.appTitle,
              style: AppTextStyles.screenTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.cardGap),
            PrimaryButton(label: l10n.loginButton, onPressed: () {}),
            const SizedBox(height: AppSpacing.cardGap),
            PrimaryButton(
              label: l10n.loginButton,
              onPressed: () {},
              isLoading: true,
            ),
            const SizedBox(height: AppSpacing.cardGap),
            OutlinedAppButton(
              label: l10n.loginButton,
              onPressed: () {},
              height: AppSizes.buttonHeightLarge,
            ),
            const SizedBox(height: AppSpacing.cardGap),
            AppTextField(
              label: l10n.emailLabel,
              hint: l10n.emailHint,
              iconAsset: AppIcons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.cardGap),
            AppTextField(
              label: l10n.emailLabel,
              hint: l10n.emailHint,
              iconAsset: AppIcons.email,
              errorText: l10n.emailInvalid,
            ),
          ],
        ),
      ),
    );
  }
}
