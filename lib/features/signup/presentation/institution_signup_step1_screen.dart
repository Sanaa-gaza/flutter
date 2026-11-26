import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/personal_info_fields.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Kept in memory once loaded, like the other option lists.
final institutionActivityTypesProvider = FutureProvider<List<ReferenceItem>>(
  (ref) => ref.watch(signupRepositoryProvider).getInstitutionActivityTypes(),
);

/// Institution signup, step 1 of 2: official info.
class InstitutionSignupStep1Screen extends ConsumerStatefulWidget {
  const InstitutionSignupStep1Screen({super.key});

  @override
  ConsumerState<InstitutionSignupStep1Screen> createState() =>
      _InstitutionSignupStep1ScreenState();
}

class _InstitutionSignupStep1ScreenState
    extends ConsumerState<InstitutionSignupStep1Screen> {
  static const double _fieldsToButton = 26;

  final _formKey = GlobalKey<FormState>();
  final _input = PersonalInfoInput();
  ReferenceItem? _activityType;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(institutionSignupDraftProvider.notifier).save((
      personalInfo: _input.toPersonalInfo(),
      activityType: _activityType!,
    ));
    context.push(AppRoutes.institutionSignupStep2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activityTypes = ref.watch(institutionActivityTypesProvider);
    // Keeps the draft alive while this step is open.
    ref.watch(institutionSignupDraftProvider);

    return SignupFormScaffold(
      title: l10n.institutionSignupTitle,
      header: AppStepIndicator(
        labels: [l10n.stepOfficialInfo, l10n.stepLegalDocuments],
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
                nameLabel: l10n.institutionNameLabel,
                nameHint: l10n.institutionNameHint,
                nameRequiredMessage: l10n.institutionNameRequired,
                emailBeforePhone: true,
                // Step 1 sends nothing: server errors show on step 2.
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
