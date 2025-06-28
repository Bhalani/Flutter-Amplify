import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth/features/auth/presentation/sign_in_screen.dart';

void main() {
  testWidgets('SignInScreen renders and validates',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
    expect(find.text('Welcome Back'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'invalid');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
