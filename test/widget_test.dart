import 'package:flutter_test/flutter_test.dart';
import 'package:aimhigher_app/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Updated to match the new constructor
    await tester.pumpWidget(const AimHigherApp(initialDarkMode: false));

    // Verify that the splash screen is shown (initial screen)
    expect(find.text('ΛIMHIGHER'), findsOneWidget);
  });
}
