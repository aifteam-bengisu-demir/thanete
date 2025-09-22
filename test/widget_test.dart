// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:thanette/src/app.dart';

void main() {
  testWidgets('App boots to splash then login', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const ThanetteApp());

    // Splash shows brand
    expect(find.text('thanette'), findsOneWidget);

    // After splash delay it navigates to login
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('get started'), findsOneWidget);
  });
}
