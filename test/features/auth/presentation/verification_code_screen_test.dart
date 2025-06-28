import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/features/auth/presentation/verification_code_screen.dart';

void main() {
  testWidgets('VerificationCodeScreen renders and validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: VerificationCodeScreen(email: 'test@example.com'),
    ));
    expect(find.text('Verification Code'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'abc');
    await tester.tap(find.text('Verify'));
    await tester.pump();
    expect(find.text('Code must be numbers only'), findsOneWidget);
  });
}
