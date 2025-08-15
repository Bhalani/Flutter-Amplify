import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

class SyncService {
  static const _apiUrl =
      'https://rh1k6y8abj.execute-api.ap-south-1.amazonaws.com/dev/transaction-link';

  Future<String?> syncAndGetRedirectUrl() async {
    final token = await _getCognitoToken();
    debugPrint("Calling POST /transaction-link with no body");
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Response status: $response');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('Response data: $data');
        // Expecting a field like 'url' in the response
        return data['url'] as String?;
      } else {
        debugPrint('Sync API error: \\${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Network error: $e');
      return null;
    }
  }

  Future<Map<String, String>> syncAndGetUrls() async {
    final token = await _getCognitoToken();
    debugPrint("Calling POST /transaction-link with no body");
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Response status: \\${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('Response data: $data');
        final url = data['url'] as String?;
        final callbackUrl = data['callback_url'] as String?;
        if (url == null || callbackUrl == null) {
          throw Exception('Missing url or callback_url from backend');
        }
        return {'url': url, 'callback_url': callbackUrl};
      } else {
        debugPrint('Sync API error: \\${response.statusCode}');
        throw Exception('Sync API error: \\${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network error: $e');
      rethrow;
    }
  }

  Map<String, String> _generateRandomParams() {
    final rand = Random();
    final firstNames = ['John', 'Jane', 'Alice', 'Bob', 'Mike', 'Sara'];
    final lastNames = ['Doe', 'Smith', 'Brown', 'Johnson', 'Lee', 'Patel'];
    final firstName = firstNames[rand.nextInt(firstNames.length)];
    final lastName = lastNames[rand.nextInt(lastNames.length)];
    final email =
        '${firstName.toLowerCase()}.${lastName.toLowerCase()}${rand.nextInt(10000)}@gmail.com';
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }

  Map<String, String> generateRandomParams() => _generateRandomParams();

  Future<String> _getCognitoToken() async {
    final session = await Amplify.Auth.fetchAuthSession();
    if (session is! CognitoAuthSession) {
      throw Exception('Not a Cognito session');
    }
    if (!session.isSignedIn) throw Exception('Not signed in');
    return session.userPoolTokensResult.value.idToken.raw;
  }
}
