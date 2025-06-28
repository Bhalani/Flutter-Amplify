import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/features/auth/presentation/sign_up_screen.dart';

void main() {
  testWidgets('SignUpScreen renders and validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));
    expect(find.text('Create Account'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(2), 'invalid');
    await tester.tap(find.text('Register'));
    await tester.pump();
    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
