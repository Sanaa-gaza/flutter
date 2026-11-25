import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/login_screen.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/verify_code_screen.dart';
import 'package:flutter_sanaa_app/features/home/presentation/home_placeholder_screen.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<void> _openLogin(WidgetTester tester) async {
  FlutterSecureStorage.setMockInitialValues({});
  final router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyCode,
        builder: (context, state) {
          final args = state.extra! as VerifyCodeArgs;
          return VerifyCodeScreen(email: args.email, purpose: args.purpose);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) =>
            HomePlaceholderScreen(role: state.extra! as UserRole),
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
}

Future<void> _login(WidgetTester tester, String email, String password) async {
  final fields = find.byType(EditableText);
  await tester.enterText(fields.at(0), email);
  await tester.enterText(fields.at(1), password);
  await tester.tap(find.byType(PrimaryButton));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('empty fields show their errors', (tester) async {
    await _openLogin(tester);
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(find.text('البريد الإلكتروني مطلوب'), findsOneWidget);
    expect(find.text('كلمة المرور مطلوبة'), findsOneWidget);
  });

  testWidgets('a wrong password shows the server message', (tester) async {
    await _openLogin(tester);
    await _login(tester, 'user@test.com', 'Wrong123!');
    expect(
      find.text('البريد الإلكتروني أو كلمة المرور غير صحيحة.'),
      findsOneWidget,
    );
  });

  testWidgets('an unverified account opens the code screen', (tester) async {
    await _openLogin(tester);
    await _login(tester, 'unverified@test.com', 'Secret1!');
    expect(find.byType(VerifyCodeScreen), findsOneWidget);
  });

  testWidgets('a customer goes straight to the logo home', (tester) async {
    await _openLogin(tester);
    await _login(tester, 'user@test.com', 'Secret1!');
    expect(find.byType(HomePlaceholderScreen), findsOneWidget);
    expect(find.textContaining('تم تسجيل دخولك'), findsNothing);
  });
}
