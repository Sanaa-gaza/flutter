import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/errors/failure_message.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_password_field.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// Last step of a password reset. [resetToken] comes from the reset code and
/// stays in memory only.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.resetToken});

  final String resetToken;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  // Sizes from the Figma change password frame.
  static const double _fieldsGap = 36;
  static const double _fieldToButton = 16;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSubmitting = false;
  String? _generalError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _generalError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            resetToken: widget.resetToken,
            password: _passwordController.text,
            passwordConfirmation: _confirmController.text,
          );
      if (!mounted) return;
      _passwordController.clear();
      _confirmController.clear();
      messenger.showSnackBar(SnackBar(content: Text(l10n.passwordChanged)));
      context.go(AppRoutes.login);
    } on Failure catch (failure) {
      if (mounted) {
        setState(() => _generalError = failureMessage(failure, l10n));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthScaffold(
      title: l10n.resetPasswordTitle,
      subtitle: Text(
        l10n.resetPasswordSubtitle,
        style: AppTextStyles.caption,
        textAlign: TextAlign.center,
      ),
      onBack: () => context.pop(),
      card: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_generalError case final error?) ...[
              AppErrorAlert(message: error),
              const SizedBox(height: _fieldToButton),
            ],
            AppPasswordField(
              label: l10n.newPasswordLabel,
              hint: l10n.passwordHint,
              controller: _passwordController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) =>
                  Validators.password(value ?? '')?.message(l10n),
            ),
            const SizedBox(height: _fieldsGap),
            AppPasswordField(
              label: l10n.confirmPasswordLabel,
              hint: l10n.confirmPasswordHint,
              controller: _confirmController,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validator: (value) => Validators.confirmPassword(
                value ?? '',
                _passwordController.text,
              )?.message(l10n),
            ),
            const SizedBox(height: _fieldToButton),
            PrimaryButton(
              label: l10n.savePasswordButton,
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
