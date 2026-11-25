import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_images.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/theme/app_colors.dart';
import 'package:flutter_sanaa_app/core/theme/app_spacing.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/widgets/app_form_card.dart';
import 'package:flutter_sanaa_app/core/widgets/app_otp_input.dart';
import 'package:flutter_sanaa_app/core/widgets/app_top_bar.dart';
import 'package:flutter_sanaa_app/core/widgets/pattern_background.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
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
  static const EdgeInsets _topBarPadding = EdgeInsets.fromLTRB(
    AppSpacing.screenHorizontal,
    14,
    AppSpacing.screenHorizontal,
    0,
  );
  static const EdgeInsets _contentPadding = EdgeInsets.fromLTRB(24, 19, 25, 24);
  static const EdgeInsets _cardPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 26,
  );
  static const double _logoWidth = 109;
  static const double _titleToSubtitle = 3;
  static const double _subtitleMaxWidth = 200;
  static const double _subtitleToCard = 34;
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
        case ResetAllowed():
        // Task 11 opens the reset password screen with the token.
      }
    } on Failure catch (failure) {
      if (mounted) _resetCode(_messageFor(failure, l10n));
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
      if (mounted) setState(() => _codeError = _messageFor(failure, l10n));
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  String _messageFor(Failure failure, AppLocalizations l10n) =>
      switch (failure) {
        NetworkFailure() => l10n.networkError,
        UnauthorizedFailure(:final message) => message ?? l10n.networkError,
        ServerFailure(:final message, :final fieldErrors) =>
          message ?? fieldErrors.values.firstOrNull ?? l10n.networkError,
      };

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

    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: _topBarPadding,
                child: AppTopBar(onBack: () => context.pop()),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: _contentPadding,
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.logoMark,
                        width: _logoWidth,
                        semanticLabel: l10n.appTitle,
                      ),
                      const SizedBox(height: AppSpacing.logoToTitle),
                      Text(
                        title,
                        style: AppTextStyles.screenTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: _titleToSubtitle),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _subtitleMaxWidth,
                        ),
                        child: Text(
                          subtitle,
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: _subtitleToCard),
                      AppFormCard(
                        padding: _cardPadding,
                        child: Column(
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
                      ),
                      const SizedBox(height: _cardToResend),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.codeNotReceived,
                            style: AppTextStyles.resendText,
                          ),
                          TextButton(
                            onPressed: _isResending || _isSubmitting
                                ? null
                                : _resend,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.padded,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
