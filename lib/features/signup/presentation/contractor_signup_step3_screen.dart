import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/upload_picker.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/app_upload_box.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/core/widgets/upload_preview.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';
import 'package:flutter_sanaa_app/features/signup/domain/contractor_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/contractor_signup_step1_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/pick_checked_upload.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_errors.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Contractor signup, step 3 of 3: the license, then the account is created.
class ContractorSignupStep3Screen extends ConsumerStatefulWidget {
  const ContractorSignupStep3Screen({super.key});

  @override
  ConsumerState<ContractorSignupStep3Screen> createState() =>
      _ContractorSignupStep3ScreenState();
}

class _ContractorSignupStep3ScreenState
    extends ConsumerState<ContractorSignupStep3Screen> {
  // Spacing measured on the Figma contractor step 3 frame.
  static const double _titleToBox = 8;
  static const double _boxToTerms = 25;
  static const double _termsToButton = 21;
  static const double _alertGap = 28;

  UploadPicked? _license;
  String? _licenseError;
  bool _termsAccepted = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;
  // Set once the account is created, when the drafts are cleared on purpose.
  bool _registered = false;
  String? _generalError;

  Future<void> _pickLicense() async {
    final file = await pickCheckedUpload(
      context,
      ref,
      allowPdf: true,
      onError: (error) => setState(() => _licenseError = error),
    );
    if (file != null) setState(() => _license = file);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final step1 = ref.read(contractorStep1DraftProvider);
    final step2 = ref.read(contractorStep2DraftProvider);
    if (step1 == null || step2 == null) return;

    final license = _license;
    setState(() {
      _generalError = null;
      _showTermsError = !_termsAccepted;
      _licenseError = license == null ? l10n.contractorLicenseRequired : null;
    });
    if (!_termsAccepted || license == null) return;

    setState(() => _isSubmitting = true);
    final repository = ref.read(signupRepositoryProvider);
    try {
      // The file goes first; the signup request carries its server path.
      final licensePath = await repository.uploadFile(license.file.path);
      await repository.registerContractor(
        ContractorSignupRequest(
          step1: step1,
          step2: step2,
          licenseFilePath: licensePath,
        ),
      );
      if (!mounted) return;
      // The password is not needed any more: drop the steps from memory.
      _registered = true;
      ref.read(contractorStep1DraftProvider.notifier).clear();
      ref.read(contractorStep2DraftProvider.notifier).clear();
      context.push(
        AppRoutes.verifyCode,
        extra: (
          email: step1.personalInfo.email,
          purpose: VerificationPurpose.register,
        ),
      );
    } on Failure catch (failure) {
      if (!mounted) return;
      // Field errors of earlier steps (e.g. email taken) show in the alert.
      final errors = splitSignupFailure(failure, const {}, l10n);
      setState(() => _generalError = errors.general);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step1 = ref.watch(contractorStep1DraftProvider);
    final step2 = ref.watch(contractorStep2DraftProvider);

    // Opened without the earlier steps (e.g. after the app restarted).
    if ((step1 == null || step2 == null) && !_registered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement(AppRoutes.contractorSignupStep1);
      });
    }

    return SignupFormScaffold(
      title: l10n.contractorSignupTitle,
      header: AppStepIndicator(
        labels: contractorStepLabels(l10n),
        currentStep: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_generalError case final error?) ...[
            AppErrorAlert(message: error),
            const SizedBox(height: _alertGap),
          ],
          Text(
            l10n.contractorLicenseTitle,
            style: AppTextStyles.sectionTitleMedium,
          ),
          const SizedBox(height: _titleToBox),
          AppUploadBox(
            label: l10n.licenseUploadLabel,
            iconAsset: AppIcons.paperclip,
            onTap: _pickLicense,
            preview: _license == null ? null : UploadPreview(upload: _license!),
            errorText: _licenseError,
          ),
          const SizedBox(height: _boxToTerms),
          AppTermsCheckbox(
            value: _termsAccepted,
            onChanged: (value) => setState(() {
              _termsAccepted = value;
              if (value) _showTermsError = false;
            }),
            errorText: _showTermsError
                ? Validators.terms(accepted: false)!.message(l10n)
                : null,
          ),
          const SizedBox(height: _termsToButton),
          PrimaryButton(
            label: l10n.nextButton,
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
