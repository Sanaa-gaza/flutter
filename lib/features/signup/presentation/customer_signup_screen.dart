import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/signup/data/signup_repository_provider.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/signup_errors.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/personal_info_fields.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/signup_form_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class CustomerSignupScreen extends ConsumerStatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  ConsumerState<CustomerSignupScreen> createState() =>
      _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends ConsumerState<CustomerSignupScreen> {
  // Spacing measured on the Figma customer frame.
  static const double _fieldsToTerms = 25;
  static const double _termsToButton = 21;

  final _formKey = GlobalKey<FormState>();
  final _input = PersonalInfoInput();

  bool _termsAccepted = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;
  Map<String, String> _serverFieldErrors = const {};
  String? _generalError;

  @override
  void dispose() {
    _input.dispose();
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
    final info = _input.toPersonalInfo();
    try {
      await ref.read(signupRepositoryProvider).registerCustomer(info);
      if (!mounted) return;
      _input.clearPasswords();
      context.push(
        AppRoutes.verifyCode,
        extra: (email: info.email, purpose: VerificationPurpose.register),
      );
    } on Failure catch (failure) {
      if (!mounted) return;
      final errors = splitSignupFailure(
        failure,
        PersonalInfoFields.fieldKeys,
        l10n,
      );
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
                const SizedBox(height: PersonalInfoFields.fieldsGap),
              ],
              PersonalInfoFields(
                input: _input,
                serverErrors: _serverFieldErrors,
                onFieldEdited: _clearServerError,
                onGovernorateChanged: (item) =>
                    setState(() => _input.governorate = item),
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
