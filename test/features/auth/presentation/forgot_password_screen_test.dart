import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/features/auth/presentation/forgot_password_screen.dart';

void main() {
  testWidgets('ForgotPasswordScreen renders and validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));
    expect(find.text('Forgot Password'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.tap(find.text('Send Code'));
    await tester.pump();
    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
