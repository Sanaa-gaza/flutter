import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/app.dart';
import 'package:flutter_sanaa_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app opens on the splash, then moves on after the animation', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SanaaApp()));
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.text('صنعة'), findsOneWidget);
  });
}
