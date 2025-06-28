import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/features/auth/presentation/verify_email_screen.dart';

void main() {
  testWidgets('VerifyEmailScreen renders and validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VerifyEmailScreen()));
    expect(find.text('Verify Email'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.tap(find.text('Send Verification Code'));
    await tester.pump();
    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
