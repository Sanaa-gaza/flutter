import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/craftsman_signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/personal_info_fields.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Craftsman signup, step 1 of 2: personal info.
class CraftsmanSignupStep1Screen extends ConsumerStatefulWidget {
  const CraftsmanSignupStep1Screen({super.key});

  @override
  ConsumerState<CraftsmanSignupStep1Screen> createState() =>
      _CraftsmanSignupStep1ScreenState();
}

class _CraftsmanSignupStep1ScreenState
    extends ConsumerState<CraftsmanSignupStep1Screen> {
  static const double _fieldsToButton = 26;

  final _formKey = GlobalKey<FormState>();
  final _input = PersonalInfoInput();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(craftsmanSignupDraftProvider.notifier)
        .savePersonalInfo(_input.toPersonalInfo());
    context.push(AppRoutes.craftsmanSignupStep2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Keeps the draft alive while this step is open.
    ref.watch(craftsmanSignupDraftProvider);

    return SignupFormScaffold(
      title: l10n.craftsmanSignupTitle,
      header: AppStepIndicator(
        labels: [l10n.stepPersonalInfo, l10n.stepCraftsmanInfo],
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
                // Step 1 sends nothing: server errors show on step 2.
                serverErrors: const {},
                onFieldEdited: (_) {},
                onGovernorateChanged: (item) =>
                    setState(() => _input.governorate = item),
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
