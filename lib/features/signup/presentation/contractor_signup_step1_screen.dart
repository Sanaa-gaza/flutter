import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_options_providers.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/personal_info_fields.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// The three step labels of the contractor signup.
List<String> contractorStepLabels(AppLocalizations l10n) => [
  l10n.stepBasicInfo,
  l10n.stepWorkInfo,
  l10n.stepLegalDocuments,
];

/// Contractor signup, step 1 of 3: basic info.
class ContractorSignupStep1Screen extends ConsumerStatefulWidget {
  const ContractorSignupStep1Screen({super.key});

  @override
  ConsumerState<ContractorSignupStep1Screen> createState() =>
      _ContractorSignupStep1ScreenState();
}

class _ContractorSignupStep1ScreenState
    extends ConsumerState<ContractorSignupStep1Screen> {
  static const double _fieldsToButton = 26;
  static const int _nationalIdLength = 9;

  final _formKey = GlobalKey<FormState>();
  final _input = PersonalInfoInput();
  final _nationalIdController = TextEditingController();
  ReferenceItem? _activityType;

  @override
  void dispose() {
    _input.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(contractorStep1DraftProvider.notifier).save((
      personalInfo: _input.toPersonalInfo(),
      nationalId: _nationalIdController.text.trim(),
      activityType: _activityType!,
    ));
    context.push(AppRoutes.contractorSignupStep2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activityTypes = ref.watch(activityTypesProvider);
    // Keeps the draft alive while this step is open.
    ref.watch(contractorStep1DraftProvider);

    return SignupFormScaffold(
      title: l10n.contractorSignupTitle,
      header: AppStepIndicator(
        labels: contractorStepLabels(l10n),
        currentStep: 0,
      ),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PersonalInfoFields(
                input: _input,
                nameLabel: l10n.quadNameLabel,
                nameHint: l10n.quadNameHint,
                nameRequiredMessage: l10n.quadNameRequired,
                afterPhone: AppTextField(
                  label: l10n.nationalIdLabel,
                  hint: l10n.nationalIdHint,
                  iconAsset: AppIcons.edit,
                  controller: _nationalIdController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_nationalIdLength),
                  ],
                  validator: (value) =>
                      Validators.nationalId(value ?? '')?.message(l10n),
                ),
                // Step 1 sends nothing: server errors show on step 3.
                serverErrors: const {},
                onFieldEdited: (_) {},
                onGovernorateChanged: (item) =>
                    setState(() => _input.governorate = item),
              ),
              const SizedBox(height: PersonalInfoFields.fieldsGap),
              AppDropdownField<ReferenceItem>(
                label: l10n.activityTypeLabel,
                hint: activityTypes.isLoading
                    ? l10n.loadingOptions
                    : l10n.activityTypeHint,
                items: activityTypes.value ?? const [],
                itemLabel: (item) => item.name,
                value: _activityType,
                onChanged: activityTypes.hasValue
                    ? (item) => setState(() => _activityType = item)
                    : null,
                errorText: activityTypes.hasError
                    ? l10n.optionsLoadError
                    : null,
                validator: (value) =>
                    value == null ? l10n.activityTypeRequired : null,
              ),
              const SizedBox(height: _fieldsToButton),
              PrimaryButton(label: l10n.nextButton, onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}
