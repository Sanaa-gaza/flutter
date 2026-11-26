import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/constants/api_constants.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_password_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_phone_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/reference_data/presentation/reference_data_providers.dart';
import 'package:flutter_sanaa_app/features/signup/domain/personal_info.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

/// Holds what the user types in [PersonalInfoFields]. The screen creates it
/// and must call [dispose].
class PersonalInfoInput {
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final address = TextEditingController();
  ReferenceItem? governorate;

  /// Call after the form validated, so the governorate is set.
  PersonalInfo toPersonalInfo() => PersonalInfo(
    fullName: fullName.text.trim(),
    phone:
        '${ApiConstants.phoneCountryCode}${Validators.cleanPhone(phone.text)}',
    email: email.text.trim(),
    password: password.text,
    governorateId: governorate!.id,
    address: address.text.trim(),
  );

  /// Removes the password from memory once it is no longer needed.
  void clearPasswords() {
    password.clear();
    confirmPassword.clear();
  }

  void dispose() {
    fullName.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    address.dispose();
  }
}

/// Name, phone, email (or email, phone), password, confirm password, governorate and address:
/// the fields every signup form starts with. Place it inside a [Form].
class PersonalInfoFields extends ConsumerWidget {
  const PersonalInfoFields({
    super.key,
    required this.input,
    required this.serverErrors,
    required this.onFieldEdited,
    required this.onGovernorateChanged,
    this.nameLabel,
    this.nameHint,
    this.nameRequiredMessage,
    this.emailBeforePhone = false,
    this.afterPhone,
  });

  final PersonalInfoInput input;

  /// The institution form names the first field differently; the defaults
  /// are the person's full name.
  final String? nameLabel;
  final String? nameHint;
  final String? nameRequiredMessage;

  /// The institution design asks for the email before the phone.
  final bool emailBeforePhone;

  /// An extra field shown right after the phone (the contractor's national
  /// ID). Only used when [emailBeforePhone] is false.
  final Widget? afterPhone;

  /// Server errors by field key (see [fieldKeys]).
  final Map<String, String> serverErrors;

  /// Called with the field key when the user edits that field.
  final ValueChanged<String> onFieldEdited;
  final ValueChanged<ReferenceItem> onGovernorateChanged;

  // Field keys used by the server for field errors.
  static const String fullNameKey = 'full_name';
  static const String phoneKey = 'phone';
  static const String emailKey = 'email';
  static const String passwordKey = 'password';
  static const String governorateKey = 'governorate_id';
  static const String addressKey = 'address';
  static const Set<String> fieldKeys = {
    fullNameKey,
    phoneKey,
    emailKey,
    passwordKey,
    governorateKey,
    addressKey,
  };

  // Spacing measured on the Figma signup frames.
  static const double fieldsGap = 28;
  static const double _columnsGap = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final governorates = ref.watch(governoratesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: nameLabel ?? l10n.fullNameLabel,
          hint: nameHint ?? l10n.fullNameHint,
          iconAsset: AppIcons.user,
          controller: input.fullName,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          errorText: serverErrors[fullNameKey],
          onChanged: (_) => onFieldEdited(fullNameKey),
          validator: (value) => Validators.required(value ?? '') == null
              ? null
              : nameRequiredMessage ?? l10n.fullNameRequired,
        ),
        const SizedBox(height: fieldsGap),
        if (emailBeforePhone) ...[
          AppTextField(
            label: l10n.emailLabel,
            hint: l10n.emailHint,
            iconAsset: AppIcons.email,
            controller: input.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            errorText: serverErrors[emailKey],
            onChanged: (_) => onFieldEdited(emailKey),
            validator: (value) => Validators.email(value ?? '')?.message(l10n),
          ),
          const SizedBox(height: fieldsGap),
          AppPhoneField(
            label: l10n.phoneLabel,
            hint: l10n.phoneHint,
            controller: input.phone,
            textInputAction: TextInputAction.next,
            errorText: serverErrors[phoneKey],
            onChanged: (_) => onFieldEdited(phoneKey),
            validator: (value) => Validators.phone(value ?? '')?.message(l10n),
          ),
        ] else ...[
          AppPhoneField(
            label: l10n.phoneLabel,
            hint: l10n.phoneHint,
            controller: input.phone,
            textInputAction: TextInputAction.next,
            errorText: serverErrors[phoneKey],
            onChanged: (_) => onFieldEdited(phoneKey),
            validator: (value) => Validators.phone(value ?? '')?.message(l10n),
          ),
          if (afterPhone case final extra?) ...[
            const SizedBox(height: fieldsGap),
            extra,
          ],
          const SizedBox(height: fieldsGap),
          AppTextField(
            label: l10n.emailLabel,
            hint: l10n.emailHint,
            iconAsset: AppIcons.email,
            controller: input.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            errorText: serverErrors[emailKey],
            onChanged: (_) => onFieldEdited(emailKey),
            validator: (value) => Validators.email(value ?? '')?.message(l10n),
          ),
        ],
        const SizedBox(height: fieldsGap),
        AppPasswordField(
          label: l10n.passwordLabel,
          hint: l10n.passwordHint,
          controller: input.password,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          errorText: serverErrors[passwordKey],
          onChanged: (_) => onFieldEdited(passwordKey),
          validator: (value) => Validators.password(value ?? '')?.message(l10n),
        ),
        const SizedBox(height: fieldsGap),
        AppPasswordField(
          label: l10n.confirmPasswordLabel,
          hint: l10n.confirmPasswordHint,
          controller: input.confirmPassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          validator: (value) => Validators.confirmPassword(
            value ?? '',
            input.password.text,
          )?.message(l10n),
        ),
        const SizedBox(height: fieldsGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: _columnsGap,
          children: [
            Expanded(
              child: AppDropdownField<ReferenceItem>(
                label: l10n.governorateLabel,
                hint: governorates.isLoading
                    ? l10n.loadingOptions
                    : l10n.governorateHint,
                items: governorates.value ?? const [],
                itemLabel: (item) => item.name,
                value: input.governorate,
                onChanged: governorates.hasValue
                    ? (item) {
                        if (item == null) return;
                        onGovernorateChanged(item);
                        onFieldEdited(governorateKey);
                      }
                    : null,
                errorText: governorates.hasError
                    ? l10n.optionsLoadError
                    : serverErrors[governorateKey],
                validator: (value) =>
                    value == null ? l10n.governorateRequired : null,
              ),
            ),
            Expanded(
              child: AppTextField(
                label: l10n.addressLabel,
                hint: l10n.addressHint,
                iconAsset: AppIcons.location,
                controller: input.address,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.streetAddressLine1],
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
                ],
                errorText: serverErrors[addressKey],
                onChanged: (_) => onFieldEdited(addressKey),
                validator: (value) => Validators.required(value ?? '') == null
                    ? null
                    : l10n.addressRequired,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
