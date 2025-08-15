import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<ResetPasswordResult> resetPassword(String email) async {
    try {
      final result = await Amplify.Auth.resetPassword(username: email.trim());
      debugPrint("Result: $result");
      debugPrint(
          'Password reset code sent. Next step: \\${result.nextStep.updateStep}');
      return result;
    } catch (e) {
      debugPrint('Error sending password reset code: $e');
      rethrow;
    }
  }

  Future<ResetPasswordResult> confirmResetPassword(
      String email, String newPassword, String code) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: email.trim(),
        newPassword: newPassword,
        confirmationCode: code,
      );
      debugPrint('Result: $result');
      debugPrint('Password reset confirmed.');
      return result;
    } catch (e) {
      debugPrint('Error confirming password reset: $e');
      rethrow;
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final result = await Amplify.Auth.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      debugPrint("result: $result");
    } on AuthException catch (e) {
      debugPrint('Error updating password: \\${e.message}');
      rethrow;
    }
  }

  // Future<void> sendUserDetailsToBackend({
  //   required String firstName,
  //   required String lastName,
  //   required String email,
  // }) async {
  //   final session = await Amplify.Auth.fetchAuthSession();
  //   if (session is! CognitoAuthSession) {
  //     debugPrint('Not a Cognito session, cannot send user details to backend.');
  //   }
  //   debugPrint("Sending detils to backend is being called: $email");
  //   final response = await http.post(
  //     Uri.parse('http://192.168.116.236:8080/users'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'email': email,
  //     }),
  //   );
  //   if (response.statusCode != 201 && response.statusCode != 200) {
  //     throw Exception('Failed to send user details: \\${response.statusCode}');
  //   }
  // }
}
