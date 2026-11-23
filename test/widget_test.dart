import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/app.dart';
import 'package:flutter_sanaa_app/app/home_placeholder_screen.dart';
import 'package:flutter_sanaa_app/features/onboarding/data/onboarding_storage.dart';
import 'package:flutter_sanaa_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter_sanaa_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOnboardingStorage implements OnboardingStorage {
  _FakeOnboardingStorage({required this.seen});

  bool seen;

  @override
  Future<bool> hasSeen() async => seen;

  @override
  Future<void> markSeen() async => seen = true;
}

Future<void> _openApp(WidgetTester tester, OnboardingStorage storage) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingStorageProvider.overrideWithValue(storage)],
      child: const SanaaApp(),
    ),
  );
  await tester.pump();
  expect(find.byType(SplashScreen), findsOneWidget);

  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
  expect(find.byType(SplashScreen), findsNothing);
}

void main() {
  testWidgets('first launch shows onboarding, skip saves it as seen', (
    tester,
  ) async {
    final storage = _FakeOnboardingStorage(seen: false);
    await _openApp(tester, storage);
    expect(find.byType(OnboardingScreen), findsOneWidget);

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePlaceholderScreen), findsOneWidget);
    expect(storage.seen, isTrue);
  });

  testWidgets('later launches skip onboarding', (tester) async {
    await _openApp(tester, _FakeOnboardingStorage(seen: true));
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(HomePlaceholderScreen), findsOneWidget);
  });
}
