import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_multiline_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_upload_box.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';
import 'package:flutter_sanaa_app/features/signup/domain/institution_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/pick_checked_photo.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_errors.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Institution signup, step 2 of 2: registration number, business license
/// and description, then the account is created.
class InstitutionSignupStep2Screen extends ConsumerStatefulWidget {
  const InstitutionSignupStep2Screen({super.key});

  @override
  ConsumerState<InstitutionSignupStep2Screen> createState() =>
      _InstitutionSignupStep2ScreenState();
}

class _InstitutionSignupStep2ScreenState
    extends ConsumerState<InstitutionSignupStep2Screen> {
  // Spacing measured on the Figma institution step 2 frame.
  static const double _fieldsGap = 28;
  static const double _licenseTextToBox = 22;
  static const double _fieldsToTerms = 25;
  static const double _termsToButton = 21;

  // Field keys used by the server for field errors.
  static const String _regNumberKey = 'commercial_registration_number';
  static const String _descriptionKey = 'description';
  static const Set<String> _fieldKeys = {_regNumberKey, _descriptionKey};

  final _formKey = GlobalKey<FormState>();
  final _regNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _license;
  String? _licenseError;
  bool _termsAccepted = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;
  // Set once the account is created, when step 1 is cleared on purpose.
  bool _registered = false;
  Map<String, String> _serverFieldErrors = const {};
  String? _generalError;

  @override
  void dispose() {
    _regNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearServerError(String key) {
    if (!_serverFieldErrors.containsKey(key)) return;
    setState(() => _serverFieldErrors = {..._serverFieldErrors}..remove(key));
  }

  Future<void> _pickLicense() async {
    final photo = await pickCheckedPhoto(
      context,
      ref,
      onError: (error) => setState(() => _licenseError = error),
    );
    if (photo != null) setState(() => _license = photo);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final step1 = ref.read(institutionSignupDraftProvider);
    if (step1 == null) return;

    final license = _license;
    setState(() {
      _generalError = null;
      _serverFieldErrors = const {};
      _showTermsError = !_termsAccepted;
      _licenseError = license == null ? l10n.licenseRequired : null;
    });
    final fieldsValid = _formKey.currentState!.validate();
    if (!fieldsValid || !_termsAccepted || license == null) return;

    setState(() => _isSubmitting = true);
    final repository = ref.read(signupRepositoryProvider);
    try {
      // The file goes first; the signup request carries its server path.
      final licensePath = await repository.uploadFile(license.path);
      await repository.registerInstitution(
        InstitutionSignupRequest(
          step1: step1,
          commercialRegistrationNumber: _regNumberController.text.trim(),
          licenseFilePath: licensePath,
          description: _descriptionController.text.trim(),
        ),
      );
      if (!mounted) return;
      // The password is not needed any more: drop step 1 from memory.
      _registered = true;
      ref.read(institutionSignupDraftProvider.notifier).clear();
      context.push(
        AppRoutes.verifyCode,
        extra: (
          email: step1.personalInfo.email,
          purpose: VerificationPurpose.register,
        ),
      );
    } on Failure catch (failure) {
      if (!mounted) return;
      // Errors for step 1 fields (e.g. email taken) show in the alert.
      final errors = splitSignupFailure(failure, _fieldKeys, l10n);
      setState(() {
        _serverFieldErrors = errors.fieldErrors;
        _generalError = errors.general;
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step1 = ref.watch(institutionSignupDraftProvider);

    // Opened without step 1 (e.g. after the app restarted): start again.
    if (step1 == null && !_registered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement(AppRoutes.institutionSignupStep1);
      });
    }

    return SignupFormScaffold(
      title: l10n.institutionSignupTitle,
      header: AppStepIndicator(
        labels: [l10n.stepOfficialInfo, l10n.stepLegalDocuments],
        currentStep: 1,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_generalError case final error?) ...[
              AppErrorAlert(message: error),
              const SizedBox(height: _fieldsGap),
            ],
            AppTextField(
              label: l10n.regNumberLabel,
              hint: l10n.regNumberHint,
              iconAsset: AppIcons.edit,
              controller: _regNumberController,
              textInputAction: TextInputAction.next,
              errorText: _serverFieldErrors[_regNumberKey],
              onChanged: (_) => _clearServerError(_regNumberKey),
              validator: (value) => Validators.required(value ?? '') == null
                  ? null
                  : l10n.regNumberRequired,
            ),
            const SizedBox(height: _fieldsGap),
            Text(l10n.licenseTitle, style: AppTextStyles.sectionTitleMedium),
            Text(
              l10n.licenseDescription,
              style: AppTextStyles.sectionDescription,
            ),
            const SizedBox(height: _licenseTextToBox),
            AppUploadBox(
              label: l10n.licenseUploadLabel,
              iconAsset: AppIcons.paperclip,
              onTap: _pickLicense,
              preview: _license == null
                  ? null
                  : Image.file(File(_license!.path), fit: BoxFit.cover),
              errorText: _licenseError,
            ),
            const SizedBox(height: _fieldsGap),
            AppMultilineField(
              label: l10n.institutionBioLabel,
              hint: l10n.institutionBioHint,
              controller: _descriptionController,
              errorText: _serverFieldErrors[_descriptionKey],
              onChanged: (_) => _clearServerError(_descriptionKey),
              validator: (value) => Validators.required(value ?? '') == null
                  ? null
                  : l10n.institutionBioRequired,
            ),
            const SizedBox(height: _fieldsToTerms),
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
      ),
    );
  }
}
