import 'package:flutter/material.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_multiline_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_password_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_phone_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/app_upload_box.dart';
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
            const SizedBox(height: AppSpacing.cardGap),
            AppPasswordField(
              label: l10n.passwordLabel,
              hint: l10n.passwordHint,
            ),
            const SizedBox(height: AppSpacing.cardGap),
            AppPhoneField(label: l10n.phoneLabel, hint: l10n.phoneHint),
            const SizedBox(height: AppSpacing.cardGap),
            AppDropdownField<String>(
              label: l10n.governorateLabel,
              hint: l10n.governorateHint,
              items: const ['1', '2', '3'],
              itemLabel: (item) => item,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.cardGap),
            AppMultilineField(label: l10n.bioLabel, hint: l10n.bioHint),
            const SizedBox(height: AppSpacing.cardGap),
            AppUploadBox(label: l10n.uploadImageLabel, onTap: () {}),
            const SizedBox(height: AppSpacing.cardGap),
            const _DemoTermsCheckbox(),
            const SizedBox(height: AppSpacing.cardGap),
            AppStepIndicator(
              labels: [l10n.stepPersonalInfo, l10n.stepCraftsmanInfo],
              currentStep: 0,
            ),
            const SizedBox(height: AppSpacing.cardGap),
            AppStepIndicator(
              labels: [l10n.stepPersonalInfo, l10n.stepCraftsmanInfo],
              currentStep: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoTermsCheckbox extends StatefulWidget {
  const _DemoTermsCheckbox();

  @override
  State<_DemoTermsCheckbox> createState() => _DemoTermsCheckboxState();
}

class _DemoTermsCheckboxState extends State<_DemoTermsCheckbox> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return AppTermsCheckbox(
      value: _accepted,
      onChanged: (value) => setState(() => _accepted = value),
    );
  }
}
