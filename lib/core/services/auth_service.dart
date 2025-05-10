import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/widgets.dart';

class AuthService extends StatefulWidget {
  Future<void> signUp(String email, String password, String firstName,
      String familyName) async {
    try {
      final userAttributes = {
        CognitoUserAttributeKey.email: email,
        CognitoUserAttributeKey.givenName: firstName,
        CognitoUserAttributeKey.familyName: familyName,
      };

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: userAttributes),
      );
      if (result.nextStep.signUpStep == CognitoSignUpStep.confirmUser) {
        setState(() {
          _isSignUpComplete = true; // Set flag to show verification screen
        });
        _showSnackBar('Please check your email for a verification code.');
      }
      print('Sign-up successful.');
    } catch (e) {
      print('Error during sign-up: $e');
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await Amplify.Auth.signIn(username: email, password: password);
      print('Sign-in successful.');
    } catch (e) {
      print('Error during sign-in: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('Sign-out successful.');
    } catch (e) {
      print('Error during sign-out: $e');
      rethrow;
    }
  }
}
