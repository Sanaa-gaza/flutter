import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/errors/failure_message.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Step 1 of a password reset: the email that gets the reset code.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  // Sizes from the Figma forgot password frame.
  static const double _subtitleToCard = 27;
  static const double _fieldToButton = 16;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isSubmitting = false;
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _emailError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final email = _emailController.text.trim();
    try {
      await ref.read(authRepositoryProvider).forgotPassword(email: email);
      if (!mounted) return;
      context.push(
        AppRoutes.verifyCode,
        extra: (email: email, purpose: VerificationPurpose.reset),
      );
    } on Failure catch (failure) {
      if (mounted) {
        setState(() => _emailError = failureMessage(failure, l10n));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthScaffold(
      title: l10n.forgotPasswordTitle,
      subtitle: Text(
        l10n.forgotPasswordSubtitle,
        style: AppTextStyles.resendText,
        textAlign: TextAlign.center,
      ),
      subtitleToCard: _subtitleToCard,
      onBack: () => context.pop(),
      card: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n.emailLabel,
              hint: l10n.emailHint,
              iconAsset: AppIcons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              errorText: _emailError,
              onChanged: (_) {
                if (_emailError != null) setState(() => _emailError = null);
              },
              validator: (value) =>
                  Validators.email(value ?? '')?.message(l10n),
            ),
            const SizedBox(height: _fieldToButton),
            PrimaryButton(
              label: l10n.sendCodeButton,
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
