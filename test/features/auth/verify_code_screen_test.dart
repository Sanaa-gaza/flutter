import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/domain/user.dart';
import 'package:flutter_sanaa_app/features/auth/domain/verification.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/verify_code_screen.dart';
import 'package:flutter_sanaa_app/features/home/presentation/home_placeholder_screen.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<void> _openCodeScreen(WidgetTester tester) async {
  FlutterSecureStorage.setMockInitialValues({});
  final router = GoRouter(
    initialLocation: AppRoutes.verifyCode,
    initialExtra: (
      email: 'craftsman@test.com',
      purpose: VerificationPurpose.register,
    ),
    routes: [
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

Future<void> _submitCode(WidgetTester tester, String code) async {
  await tester.enterText(find.byType(EditableText), code);
  await tester.tap(find.byType(PrimaryButton));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a short code asks for all 6 digits', (tester) async {
    await _openCodeScreen(tester);
    await _submitCode(tester, '123');
    expect(find.text('يرجى إدخال الرمز المكوّن من 6 أرقام'), findsOneWidget);
  });

  testWidgets('a wrong code clears the boxes and shows the error', (
    tester,
  ) async {
    await _openCodeScreen(tester);
    await _submitCode(tester, '000000');
    expect(find.text('رمز التحقق غير صحيح أو منتهي الصلاحية.'), findsOneWidget);
    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.controller.text, isEmpty);
  });

  testWidgets('the right code opens the home of the returned role', (
    tester,
  ) async {
    await _openCodeScreen(tester);
    await _submitCode(tester, '123456');
    expect(find.byType(HomePlaceholderScreen), findsOneWidget);
    expect(find.text('تم تسجيل دخولك كـ حرفي'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('تم تسجيل دخولك كـ حرفي'), findsNothing);
  });
}
