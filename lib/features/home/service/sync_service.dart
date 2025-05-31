import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/sync_result.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

class SyncService {
  static const _apiUrl = 'http://localhost:3000/register';

  Future<SyncResult> sync() async {
    final params = _generateRandomParams();
    final token = await _getCognitoToken();
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(params),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SyncResult(
        userId: data['user_id'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        email: data['email'],
      );
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception('Validation error: ${data['errors']}');
    } else {
      throw Exception('Server error: ${response.statusCode}');
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

  Future<String> _getCognitoToken() async {
    final session = await Amplify.Auth.fetchAuthSession();
    if (session is! CognitoAuthSession)
      throw Exception('Not a Cognito session');
    if (!session.isSignedIn) throw Exception('Not signed in');
    return session.userPoolTokensResult.value.idToken.raw;
  }
}
