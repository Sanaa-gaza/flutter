import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/errors/failure_message.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/photo_picker.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_multiline_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_step_indicator.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_upload_box.dart';
import 'package:flutter_sanaa_app/core/widgets/photo_source_sheet.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/reference_data/presentation/reference_data_providers.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';
import 'package:flutter_sanaa_app/features/signup/domain/craftsman_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/craftsman_signup_draft.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_errors.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/profile_photo_picker.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Craftsman signup, step 2 of 2: craft, bio and photos, then the account
/// is created.
class CraftsmanSignupStep2Screen extends ConsumerStatefulWidget {
  const CraftsmanSignupStep2Screen({super.key});

  @override
  ConsumerState<CraftsmanSignupStep2Screen> createState() =>
      _CraftsmanSignupStep2ScreenState();
}

class _CraftsmanSignupStep2ScreenState
    extends ConsumerState<CraftsmanSignupStep2Screen> {
  // Spacing measured on the Figma craftsman step 2 frame.
  static const double _fieldsGap = 28;
  static const double _photoToFields = 16;
  static const double _otherCraftGap = 10;
  static const double _idTextToBox = 20;
  static const double _fieldsToTerms = 25;
  static const double _termsToButton = 21;

  // Field keys used by the server for field errors.
  static const String _craftKey = 'craft';
  static const String _customCraftKey = 'custom_craft_name';
  static const String _bioKey = 'bio';
  static const Set<String> _fieldKeys = {_craftKey, _customCraftKey, _bioKey};

  // The app adds "Other" after the services list; its id is never sent.
  static const int _otherCraftId = -1;

  final _formKey = GlobalKey<FormState>();
  final _customCraftController = TextEditingController();
  final _bioController = TextEditingController();

  ReferenceItem? _craft;
  XFile? _profilePhoto;
  XFile? _idSelfie;
  String? _profilePhotoError;
  String? _idSelfieError;
  bool _termsAccepted = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;
  // Set once the account is created, when step 1 is cleared on purpose.
  bool _registered = false;
  Map<String, String> _serverFieldErrors = const {};
  String? _generalError;

  bool get _isOtherCraft => _craft?.id == _otherCraftId;

  @override
  void dispose() {
    _customCraftController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _clearServerError(String key) {
    if (!_serverFieldErrors.containsKey(key)) return;
    setState(() => _serverFieldErrors = {..._serverFieldErrors}..remove(key));
  }

  /// Asks camera or gallery, picks and checks the photo. Returns null when
  /// nothing usable was chosen; [onError] gets the reason to show.
  Future<XFile?> _pickPhoto(ValueChanged<String?> onError) async {
    final l10n = AppLocalizations.of(context);
    final source = await showPhotoSourceSheet(context);
    if (source == null || !mounted) return null;

    final result = await ref.read(photoPickerProvider).pick(source);
    if (!mounted) return null;
    switch (result) {
      case PhotoPicked(:final photo):
        onError(null);
        return photo;
      case PhotoCancelled():
        return null;
      case PhotoTooLarge():
        onError(l10n.photoTooLarge);
      case PhotoUnsupportedType():
        onError(l10n.photoUnsupportedType);
    }
    return null;
  }

  Future<void> _pickProfilePhoto() async {
    final photo = await _pickPhoto(
      (error) => setState(() => _profilePhotoError = error),
    );
    if (photo != null) setState(() => _profilePhoto = photo);
  }

  Future<void> _pickIdSelfie() async {
    final photo = await _pickPhoto(
      (error) => setState(() => _idSelfieError = error),
    );
    if (photo != null) setState(() => _idSelfie = photo);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final personalInfo = ref.read(craftsmanSignupDraftProvider);
    if (personalInfo == null) return;

    final profilePhoto = _profilePhoto;
    final idSelfie = _idSelfie;
    setState(() {
      _generalError = null;
      _serverFieldErrors = const {};
      _showTermsError = !_termsAccepted;
      _profilePhotoError = profilePhoto == null ? l10n.avatarRequired : null;
      _idSelfieError = idSelfie == null ? l10n.idSelfieRequired : null;
    });
    final fieldsValid = _formKey.currentState!.validate();
    if (!fieldsValid ||
        !_termsAccepted ||
        profilePhoto == null ||
        idSelfie == null) {
      return;
    }

    setState(() => _isSubmitting = true);
    final repository = ref.read(signupRepositoryProvider);
    try {
      // Files go first; the signup request carries their server paths.
      final (photoPath, selfiePath) = await (
        repository.uploadFile(profilePhoto.path),
        repository.uploadFile(idSelfie.path),
      ).wait;
      final request = CraftsmanSignupRequest(
        personalInfo: personalInfo,
        craftId: _isOtherCraft ? null : _craft!.id,
        customCraftName: _isOtherCraft
            ? _customCraftController.text.trim()
            : null,
        bio: _bioController.text.trim(),
        personalPhotoPath: photoPath,
        idSelfiePath: selfiePath,
      );
      await repository.registerCraftsman(request);
      if (!mounted) return;
      // The password is not needed any more: drop step 1 from memory.
      _registered = true;
      ref.read(craftsmanSignupDraftProvider.notifier).clear();
      context.push(
        AppRoutes.verifyCode,
        extra: (
          email: personalInfo.email,
          purpose: VerificationPurpose.register,
        ),
      );
    } on ParallelWaitError<
      (String?, String?),
      (AsyncError?, AsyncError?)
    > catch (error) {
      if (!mounted) return;
      final failure = error.errors.$1?.error ?? error.errors.$2?.error;
      setState(
        () => _generalError = failure is Failure
            ? failureMessage(failure, l10n)
            : l10n.networkError,
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
    final personalInfo = ref.watch(craftsmanSignupDraftProvider);
    final services = ref.watch(servicesProvider);
    final otherCraft = ReferenceItem(id: _otherCraftId, name: l10n.otherCraft);

    // Opened without step 1 (e.g. after the app restarted): start again.
    if (personalInfo == null && !_registered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement(AppRoutes.craftsmanSignupStep1);
      });
    }

    return SignupFormScaffold(
      title: l10n.craftsmanSignupTitle,
      header: AppStepIndicator(
        labels: [l10n.stepPersonalInfo, l10n.stepCraftsmanInfo],
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
            Center(
              child: ProfilePhotoPicker(
                label: l10n.addProfilePhoto,
                onTap: _pickProfilePhoto,
                photo: _profilePhoto == null
                    ? null
                    : FileImage(File(_profilePhoto!.path)),
                errorText: _profilePhotoError,
              ),
            ),
            const SizedBox(height: _photoToFields),
            AppDropdownField<ReferenceItem>(
              label: l10n.craftLabel,
              hint: services.isLoading ? l10n.loadingOptions : l10n.craftHint,
              items: [...?services.value, if (services.hasValue) otherCraft],
              itemLabel: (item) => item.name,
              value: _craft,
              onChanged: services.hasValue
                  ? (item) {
                      setState(() => _craft = item);
                      _clearServerError(_craftKey);
                    }
                  : null,
              errorText: services.hasError
                  ? l10n.optionsLoadError
                  : _serverFieldErrors[_craftKey],
              validator: (value) => value == null ? l10n.craftRequired : null,
            ),
            if (_isOtherCraft) ...[
              const SizedBox(height: _otherCraftGap),
              AppTextField(
                label: l10n.otherCraft,
                hint: l10n.customCraftHint,
                controller: _customCraftController,
                textInputAction: TextInputAction.next,
                errorText: _serverFieldErrors[_customCraftKey],
                onChanged: (_) => _clearServerError(_customCraftKey),
                validator: (value) => Validators.required(value ?? '') == null
                    ? null
                    : l10n.customCraftRequired,
              ),
            ],
            const SizedBox(height: _fieldsGap),
            AppMultilineField(
              label: l10n.bioLabel,
              hint: l10n.bioHint,
              controller: _bioController,
              errorText: _serverFieldErrors[_bioKey],
              onChanged: (_) => _clearServerError(_bioKey),
              validator: (value) => Validators.bio(value ?? '')?.message(l10n),
            ),
            const SizedBox(height: _fieldsGap),
            Text(l10n.idSelfieTitle, style: AppTextStyles.sectionTitleMedium),
            Text(
              l10n.idSelfieDescription,
              style: AppTextStyles.sectionDescription,
            ),
            const SizedBox(height: _idTextToBox),
            AppUploadBox(
              label: l10n.uploadImageLabel,
              onTap: _pickIdSelfie,
              preview: _idSelfie == null
                  ? null
                  : Image.file(File(_idSelfie!.path), fit: BoxFit.cover),
              errorText: _idSelfieError,
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
