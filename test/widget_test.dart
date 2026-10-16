import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sanaa_app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts in Arabic and shows the app title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SanaaApp()));
    await tester.pumpAndSettle();

    expect(find.text('صنعة'), findsOneWidget);
  });
}
