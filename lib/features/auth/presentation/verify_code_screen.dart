import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/errors/failure_message.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_otp_input.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// The 6-digit email code screen, used after signup and for a password reset.
class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.email,
    required this.purpose,
  });

  final String email;
  final VerificationPurpose purpose;

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  // Sizes from the Figma code frame.
  static const double _codeToButton = 16;
  static const double _cardToResend = 18;

  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  bool _isSubmitting = false;
  bool _isResending = false;
  String? _codeError;

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  // After a wrong code: empty boxes, focus on the first one, show the error.
  void _resetCode(String error) {
    _codeController.clear();
    _codeFocusNode.requestFocus();
    setState(() => _codeError = error);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text;
    if (code.length != AppOtpInput.length) {
      setState(() => _codeError = l10n.codeRequired);
      return;
    }

    setState(() {
      _codeError = null;
      _isSubmitting = true;
    });
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .verifyEmail(
            email: widget.email,
            code: code,
            purpose: widget.purpose,
          );
      if (!mounted) return;
      switch (result) {
        case VerifiedSession(:final user):
          context.go(AppRoutes.home, extra: user.role);
        case ResetAllowed(:final resetToken):
          context.pushReplacement(AppRoutes.resetPassword, extra: resetToken);
      }
    } on Failure catch (failure) {
      if (mounted) _resetCode(failureMessage(failure, l10n));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isResending = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .resendCode(email: widget.email, purpose: widget.purpose);
      if (!mounted) return;
      _codeController.clear();
      setState(() => _codeError = null);
      messenger.showSnackBar(SnackBar(content: Text(l10n.codeResent)));
    } on Failure catch (failure) {
      if (mounted) setState(() => _codeError = failureMessage(failure, l10n));
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, subtitle) = switch (widget.purpose) {
      VerificationPurpose.register => (
        l10n.verifyEmailTitle,
        l10n.verifyEmailSubtitle,
      ),
      VerificationPurpose.reset => (
        l10n.forgotPasswordTitle,
        l10n.resetCodeSubtitle,
      ),
    };

    return AuthScaffold(
      title: title,
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption,
        textAlign: TextAlign.center,
      ),
      onBack: () => context.pop(),
      card: Column(
        children: [
          AppOtpInput(
            label: l10n.otpLabel,
            controller: _codeController,
            focusNode: _codeFocusNode,
            errorText: _codeError,
          ),
          const SizedBox(height: _codeToButton),
          PrimaryButton(
            label: l10n.confirmCodeButton,
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: _cardToResend),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.codeNotReceived, style: AppTextStyles.resendText),
            TextButton(
              onPressed: _isResending || _isSubmitting ? null : _resend,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(
                l10n.resendCode,
                style: AppTextStyles.resendText.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
