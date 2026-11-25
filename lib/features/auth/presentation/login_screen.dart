import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/constants/app_icons.dart';
import 'package:flutter_sanaa_app/core/errors/failure.dart';
import 'package:flutter_sanaa_app/core/errors/failure_message.dart';
import 'package:flutter_sanaa_app/core/theme/app_text_styles.dart';
import 'package:flutter_sanaa_app/core/utils/validation_error_text.dart';
import 'package:flutter_sanaa_app/core/utils/validators.dart';
import 'package:flutter_sanaa_app/core/widgets/app_error_alert.dart';
import 'package:flutter_sanaa_app/core/widgets/app_password_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_text_field.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Sizes from the Figma login frame.
  static const double _subtitleToCard = 27;
  static const double _fieldsGap = 22;
  static const double _passwordToForgot = 15;
  static const double _forgotToButton = 21;
  static const double _cardToPrompt = 33;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _subtitleLinkRecognizer = TapGestureRecognizer()
    ..onTap = _openSignup;

  bool _isSubmitting = false;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _subtitleLinkRecognizer.dispose();
    super.dispose();
  }

  void _openSignup() => context.push(AppRoutes.goal);

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _generalError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final email = _emailController.text.trim();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: _passwordController.text);
      if (!mounted) return;
      _passwordController.clear();
      context.go(AppRoutes.home, extra: user.role);
    } on Failure catch (failure) {
      if (!mounted) return;
      if (failure case ServerFailure(requiresVerification: true)) {
        _passwordController.clear();
        // The account exists but its email is not verified yet.
        context.push(
          AppRoutes.verifyCode,
          extra: (email: email, purpose: VerificationPurpose.register),
        );
      } else {
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
      title: l10n.loginButton,
      subtitle: Text.rich(
        TextSpan(
          text: l10n.loginNoAccountPrefix,
          children: [
            TextSpan(
              text: l10n.createAccountButton,
              style: const TextStyle(fontWeight: FontWeight.w700),
              recognizer: _subtitleLinkRecognizer,
            ),
          ],
        ),
        style: AppTextStyles.resendText,
        textAlign: TextAlign.center,
      ),
      subtitleToCard: _subtitleToCard,
      onBack: () =>
          context.canPop() ? context.pop() : context.go(AppRoutes.welcome),
      card: _buildForm(l10n),
      footer: Padding(
        padding: const EdgeInsets.only(top: _cardToPrompt),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.loginNoAccount, style: AppTextStyles.mutedPrompt),
            TextButton(
              onPressed: _openSignup,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: Text(l10n.createAccountButton, style: AppTextStyles.link),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Form(
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
              label: l10n.emailLabel,
              hint: l10n.emailHint,
              iconAsset: AppIcons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: (value) =>
                  Validators.email(value ?? '')?.message(l10n),
            ),
            const SizedBox(height: _fieldsGap),
            AppPasswordField(
              label: l10n.passwordLabel,
              hint: l10n.loginPasswordHint,
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              // Login only checks that a password was typed; its strength
              // rules apply when creating an account.
              validator: (value) => (value ?? '').isEmpty
                  ? ValidationError.passwordRequired.message(l10n)
                  : null,
            ),
            const SizedBox(height: _passwordToForgot),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(
                  l10n.forgotPasswordLink,
                  style: AppTextStyles.forgotPasswordLink,
                ),
              ),
            ),
            const SizedBox(height: _forgotToButton),
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
