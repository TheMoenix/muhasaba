// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muhasaba/app.dart';
import 'package:muhasaba/features/home/home_controller.dart';

void main() {
  testWidgets('App launches and shows home page', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MuhasabaApp(),
      ),
    );

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that our app shows the main page with expected elements
    expect(find.text('Muhasaba'), findsOneWidget);
  });
}
