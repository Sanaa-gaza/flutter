import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/forgot_password_screen.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/login_screen.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/reset_password_screen.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/verify_code_screen.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<void> _tapButton(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(PrimaryButton));
  await tester.tap(find.byType(PrimaryButton));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('forgot password: email, code, new password, back to login', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    final router = GoRouter(
      initialLocation: AppRoutes.forgotPassword,
      routes: [
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.verifyCode,
          builder: (context, state) {
            final args = state.extra! as VerifyCodeArgs;
            return VerifyCodeScreen(email: args.email, purpose: args.purpose);
          },
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (context, state) =>
              ResetPasswordScreen(resetToken: state.extra! as String),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), 'user@test.com');
    await _tapButton(tester);
    expect(find.byType(VerifyCodeScreen), findsOneWidget);
    expect(find.text('نسيت كلمة المرور'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), '123456');
    await _tapButton(tester);
    expect(find.byType(ResetPasswordScreen), findsOneWidget);

    final fields = find.byType(EditableText);
    await tester.enterText(fields.at(0), 'NewPass1!');
    await tester.enterText(fields.at(1), 'NewPass1!');
    await _tapButton(tester);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      find.text('تم تغيير كلمة المرور بنجاح، سجّل دخولك بكلمة المرور الجديدة'),
      findsOneWidget,
    );
  });
}
