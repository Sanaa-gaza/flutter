import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_multiline_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/contractor_signup_step1_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_options_providers.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Contractor signup, step 2 of 3: work info.
class ContractorSignupStep2Screen extends ConsumerStatefulWidget {
  const ContractorSignupStep2Screen({super.key});

  @override
  ConsumerState<ContractorSignupStep2Screen> createState() =>
      _ContractorSignupStep2ScreenState();
}

class _ContractorSignupStep2ScreenState
    extends ConsumerState<ContractorSignupStep2Screen> {
  // Spacing measured on the Figma contractor step 2 frame.
  static const double _fieldsGap = 28;
  static const double _fieldsToButton = 26;

  final _formKey = GlobalKey<FormState>();
  final _specializationController = TextEditingController();
  final _descriptionController = TextEditingController();
  ReferenceItem? _workersCount;

  @override
  void dispose() {
    _specializationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    final description = _descriptionController.text.trim();
    ref.read(contractorStep2DraftProvider.notifier).save((
      workersCount: _workersCount!,
      mainSpecialization: _specializationController.text.trim(),
      // Optional: not sent when empty.
      description: description.isEmpty ? null : description,
    ));
    context.push(AppRoutes.contractorSignupStep3);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step1 = ref.watch(contractorStep1DraftProvider);
    final workersOptions = ref.watch(workersCountOptionsProvider);
    // Keeps the step 2 draft alive while this step is open.
    ref.watch(contractorStep2DraftProvider);

    // Opened without step 1 (e.g. after the app restarted): start again.
    if (step1 == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement(AppRoutes.contractorSignupStep1);
      });
    }

    return SignupFormScaffold(
      title: l10n.contractorSignupTitle,
      header: AppStepIndicator(
        labels: contractorStepLabels(l10n),
        currentStep: 1,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppDropdownField<ReferenceItem>(
              label: l10n.workersCountLabel,
              hint: workersOptions.isLoading
                  ? l10n.loadingOptions
                  : l10n.workersCountHint,
              items: workersOptions.value ?? const [],
              itemLabel: (item) => item.name,
              value: _workersCount,
              onChanged: workersOptions.hasValue
                  ? (item) => setState(() => _workersCount = item)
                  : null,
              errorText: workersOptions.hasError ? l10n.optionsLoadError : null,
              validator: (value) =>
                  value == null ? l10n.workersCountRequired : null,
            ),
            const SizedBox(height: _fieldsGap),
            AppTextField(
              label: l10n.mainSpecializationLabel,
              hint: l10n.mainSpecializationHint,
              iconAsset: AppIcons.edit,
              controller: _specializationController,
              textInputAction: TextInputAction.next,
              validator: (value) => Validators.required(value ?? '') == null
                  ? null
                  : l10n.mainSpecializationRequired,
            ),
            const SizedBox(height: _fieldsGap),
            AppMultilineField(
              label: l10n.institutionBioLabel,
              hint: l10n.contractorBioHint,
              controller: _descriptionController,
            ),
            const SizedBox(height: _fieldsToButton),
            PrimaryButton(label: l10n.nextButton, onPressed: _next),
          ],
        ),
      ),
    );
  }
}
