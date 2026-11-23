import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/core/constants/api_constants.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_password_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_phone_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/reference_data/domain/reference_item.dart';
import 'package:flutter_sanaa_app/features/reference_data/presentation/reference_data_providers.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';
import 'package:flutter_sanaa_app/features/signup/domain/customer_signup_request.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';

class CustomerSignupScreen extends ConsumerStatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  ConsumerState<CustomerSignupScreen> createState() =>
      _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends ConsumerState<CustomerSignupScreen> {
  // Spacing measured on the Figma customer frame.
  static const double _fieldsGap = 28;
  static const double _columnsGap = 10;
  static const double _fieldsToTerms = 25;
  static const double _termsToButton = 21;

  // Field keys used by the server for field errors.
  static const String _fullNameKey = 'full_name';
  static const String _phoneKey = 'phone';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _governorateKey = 'governorate_id';
  static const String _addressKey = 'address';
  static const Set<String> _fieldKeys = {
    _fullNameKey,
    _phoneKey,
    _emailKey,
    _passwordKey,
    _governorateKey,
    _addressKey,
  };

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  ReferenceItem? _governorate;
  bool _termsAccepted = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;
  Map<String, String> _serverFieldErrors = const {};
  String? _generalError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // A server error is cleared as soon as the user edits that field.
  void _clearServerError(String key) {
    if (!_serverFieldErrors.containsKey(key)) return;
    setState(() => _serverFieldErrors = {..._serverFieldErrors}..remove(key));
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _generalError = null;
      _serverFieldErrors = const {};
      _showTermsError = !_termsAccepted;
    });
    final fieldsValid = _formKey.currentState!.validate();
    if (!fieldsValid || !_termsAccepted) return;

    setState(() => _isSubmitting = true);
    final request = CustomerSignupRequest(
      fullName: _fullNameController.text.trim(),
      phone:
          '${ApiConstants.phoneCountryCode}'
          '${Validators.cleanPhone(_phoneController.text)}',
      email: _emailController.text.trim(),
      password: _passwordController.text,
      governorateId: _governorate!.id,
      address: _addressController.text.trim(),
    );

    try {
      await ref.read(signupRepositoryProvider).registerCustomer(request);
      if (!mounted) return;
      // The password is not needed any more: remove it from memory.
      _passwordController.clear();
      _confirmPasswordController.clear();
      // Task 10 opens the email verification screen here.
    } on Failure catch (failure) {
      if (!mounted) return;
      setState(() => _showFailure(failure, l10n));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showFailure(Failure failure, AppLocalizations l10n) {
    switch (failure) {
      case NetworkFailure():
        _generalError = l10n.networkError;
      case UnauthorizedFailure(:final message):
        _generalError = message ?? l10n.networkError;
      case ServerFailure(:final message, :final fieldErrors):
        _serverFieldErrors = {
          for (final MapEntry(:key, :value) in fieldErrors.entries)
            if (_fieldKeys.contains(key)) key: value,
        };
        // Errors for fields that are not on this screen go to the alert.
        final otherErrors = [
          for (final MapEntry(:key, :value) in fieldErrors.entries)
            if (!_fieldKeys.contains(key)) value,
        ];
        final generalLines = [?message, ...otherErrors];
        _generalError = generalLines.isEmpty && _serverFieldErrors.isEmpty
            ? l10n.networkError
            : generalLines.isEmpty
            ? null
            : generalLines.join('\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final governorates = ref.watch(governoratesProvider);

    return SignupFormScaffold(
      title: l10n.customerSignupTitle,
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_generalError case final error?) ...[
                AppErrorAlert(message: error),
                const SizedBox(height: _fieldsGap),
              ],
              AppTextField(
                label: l10n.fullNameLabel,
                hint: l10n.fullNameHint,
                iconAsset: AppIcons.user,
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                errorText: _serverFieldErrors[_fullNameKey],
                onChanged: (_) => _clearServerError(_fullNameKey),
                validator: (value) => Validators.required(value ?? '') == null
                    ? null
                    : l10n.fullNameRequired,
              ),
              const SizedBox(height: _fieldsGap),
              AppPhoneField(
                label: l10n.phoneLabel,
                hint: l10n.phoneHint,
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                errorText: _serverFieldErrors[_phoneKey],
                onChanged: (_) => _clearServerError(_phoneKey),
                validator: (value) =>
                    Validators.phone(value ?? '')?.message(l10n),
              ),
              const SizedBox(height: _fieldsGap),
              AppTextField(
                label: l10n.emailLabel,
                hint: l10n.emailHint,
                iconAsset: AppIcons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                errorText: _serverFieldErrors[_emailKey],
                onChanged: (_) => _clearServerError(_emailKey),
                validator: (value) =>
                    Validators.email(value ?? '')?.message(l10n),
              ),
              const SizedBox(height: _fieldsGap),
              AppPasswordField(
                label: l10n.passwordLabel,
                hint: l10n.passwordHint,
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                errorText: _serverFieldErrors[_passwordKey],
                onChanged: (_) => _clearServerError(_passwordKey),
                validator: (value) =>
                    Validators.password(value ?? '')?.message(l10n),
              ),
              const SizedBox(height: _fieldsGap),
              AppPasswordField(
                label: l10n.confirmPasswordLabel,
                hint: l10n.confirmPasswordHint,
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: (value) => Validators.confirmPassword(
                  value ?? '',
                  _passwordController.text,
                )?.message(l10n),
              ),
              const SizedBox(height: _fieldsGap),
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
                      value: _governorate,
                      onChanged: governorates.hasValue
                          ? (item) {
                              setState(() => _governorate = item);
                              _clearServerError(_governorateKey);
                            }
                          : null,
                      errorText: governorates.hasError
                          ? l10n.optionsLoadError
                          : _serverFieldErrors[_governorateKey],
                      validator: (value) =>
                          value == null ? l10n.governorateRequired : null,
                    ),
                  ),
                  Expanded(
                    child: AppTextField(
                      label: l10n.addressLabel,
                      hint: l10n.addressHint,
                      iconAsset: AppIcons.location,
                      controller: _addressController,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.streetAddressLine1],
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
                      ],
                      errorText: _serverFieldErrors[_addressKey],
                      onChanged: (_) => _clearServerError(_addressKey),
                      validator: (value) =>
                          Validators.required(value ?? '') == null
                          ? null
                          : l10n.addressRequired,
                    ),
                  ),
                ],
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
      ),
    );
  }
}
