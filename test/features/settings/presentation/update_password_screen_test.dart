import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/features/settings/presentation/update_password_screen.dart';

void main() {
  testWidgets('UpdatePasswordScreen renders and validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: UpdatePasswordScreen()));
    expect(find.text('Update Password'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'short');
    await tester.tap(find.text('Update Password'));
    await tester.pump();
    expect(
        find.text('Password must be at least 12 characters'), findsOneWidget);
  });
}
