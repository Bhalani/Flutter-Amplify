import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class AuthService {
  Future<SignUpResult> signUp(String email, String password, String firstName,
      String familyName) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.name: firstName,
        AuthUserAttributeKey.familyName: familyName,
      };

      return await Amplify.Auth.signUp(
        username: email.trim().toLowerCase(),
        password: password,
        options: SignUpOptions(userAttributes: userAttributes),
      );
    } catch (e) {
      debugPrint('Error during sign-up: $e');
      rethrow;
    }
  }

  Future<SignUpResult> confirmSignUp(
      String email, String confirmationCode) async {
    try {
      return await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
    } catch (e) {
      debugPrint('Error during confirmation: $e');
      rethrow;
    }
  }

  Future<SignInResult> signIn(String email, String password) async {
    try {
      return await Amplify.Auth.signIn(username: email, password: password);
    } catch (e) {
      debugPrint('Error during sign-in: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      debugPrint('Sign-out successful.');
    } catch (e) {
      debugPrint('Error during sign-out: $e');
      rethrow;
    }
  }

  Future<void> resendVerificationCode(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      debugPrint('Verification code resent successfully.');
    } catch (e) {
      debugPrint('Error resending verification code: $e');
      rethrow;
    }
  }
}
