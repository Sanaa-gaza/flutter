import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/router.dart';
import 'package:flutter_sanaa_app/core/utils/photo_picker.dart';
import 'package:flutter_sanaa_app/core/widgets/app_dropdown_field.dart';
import 'package:flutter_sanaa_app/core/widgets/app_terms_checkbox.dart';
import 'package:flutter_sanaa_app/core/widgets/app_upload_box.dart';
import 'package:flutter_sanaa_app/core/widgets/primary_button.dart';
import 'package:flutter_sanaa_app/features/auth/presentation/verify_code_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/craftsman_signup_step1_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/craftsman_signup_step2_screen.dart';
import 'package:flutter_sanaa_app/features/signup/presentation/widgets/profile_photo_picker.dart';
import 'package:flutter_sanaa_app/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Returns a small real PNG instead of opening the camera or gallery.
class _FakePhotoPicker implements PhotoPicker {
  _FakePhotoPicker(this.path);

  final String path;

  @override
  Future<PhotoPickResult> pick(PhotoSource source) async =>
      PhotoPicked(XFile(path));
}

// A 1x1 transparent PNG.
const List<int> _pngBytes = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

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
  final photo = File('${Directory.systemTemp.path}/sanaa_test_photo.png')
    ..writeAsBytesSync(_pngBytes);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        photoPickerProvider.overrideWithValue(_FakePhotoPicker(photo.path)),
      ],
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

Future<void> _pickFromGallery(WidgetTester tester, Finder slot) async {
  await tester.tap(slot);
  await tester.pumpAndSettle();
  await tester.tap(find.text('المعرض'));
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
    await _pickFromGallery(tester, find.byType(ProfilePhotoPicker));
    await _pickFromGallery(tester, find.byType(AppUploadBox));
    await tester.tap(find.byType(AppTermsCheckbox));
    await _tapNext(tester);

    expect(find.byType(VerifyCodeScreen), findsOneWidget);
  });

  testWidgets('both photos are required', (tester) async {
    await _openStep1(tester);
    await _fillStep1(tester);

    await _tapNext(tester);

    expect(find.text('يرجى إضافة صورة شخصية'), findsOneWidget);
    expect(find.text('يرجى إرفاق صورة شخصية وأنت ماسك هويتك'), findsOneWidget);
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
