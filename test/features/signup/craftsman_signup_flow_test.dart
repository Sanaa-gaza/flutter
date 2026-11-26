import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/verify_code_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/craftsman_signup_step1_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/craftsman_signup_step2_screen.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<void> _openStep1(WidgetTester tester) async {
  tester.view.physicalSize = const Size(414, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: AppRoutes.craftsmanSignupStep1,
    routes: [
      GoRoute(
        path: AppRoutes.craftsmanSignupStep1,
        builder: (context, state) => const CraftsmanSignupStep1Screen(),
      ),
      GoRoute(
        path: AppRoutes.craftsmanSignupStep2,
        builder: (context, state) => const CraftsmanSignupStep2Screen(),
      ),
      GoRoute(
        path: AppRoutes.verifyCode,
        builder: (context, state) {
          final args = state.extra! as VerifyCodeArgs;
          return VerifyCodeScreen(email: args.email, purpose: args.purpose);
        },
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
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> _choose(WidgetTester tester, int dropdown, String item) async {
  // Waits for the mock list to load.
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  await tester.tap(
    find.byWidgetPredicate((widget) => widget is AppDropdownField).at(dropdown),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(item).last);
  await tester.pumpAndSettle();
}

Future<void> _tapNext(WidgetTester tester) async {
  await tester.tap(find.byType(PrimaryButton));
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

Future<void> _fillStep1(WidgetTester tester) async {
  final fields = find.byType(EditableText);
  await tester.enterText(fields.at(0), 'حرفي تجريبي');
  await tester.enterText(fields.at(1), '599123456');
  await tester.enterText(fields.at(2), 'craftsman@test.com');
  await tester.enterText(fields.at(3), 'Secret1!');
  await tester.enterText(fields.at(4), 'Secret1!');
  await tester.enterText(fields.at(5), 'الرمال');
  await _choose(tester, 0, 'غزة');
  await _tapNext(tester);
}

void main() {
  testWidgets('step 1 then step 2 creates the account and asks for the code', (
    tester,
  ) async {
    await _openStep1(tester);
    await _fillStep1(tester);
    expect(find.byType(CraftsmanSignupStep2Screen), findsOneWidget);

    await _choose(tester, 0, 'نجارة');
    await tester.enterText(
      find.byType(EditableText).first,
      'خبرة عشر سنوات في النجارة',
    );
    await tester.tap(find.byType(AppTermsCheckbox));
    await _tapNext(tester);

    expect(find.byType(VerifyCodeScreen), findsOneWidget);
  });

  testWidgets('"Other" craft asks for the craft name', (tester) async {
    await _openStep1(tester);
    await _fillStep1(tester);

    await _choose(tester, 0, 'أخرى');
    await tester.tap(find.byType(AppTermsCheckbox));
    await _tapNext(tester);

    expect(find.text('يرجى كتابة اسم مهنتك'), findsOneWidget);
    expect(find.byType(CraftsmanSignupStep2Screen), findsOneWidget);
  });
}
