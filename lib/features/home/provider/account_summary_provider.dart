import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../model/account_summary.dart';

// Provider for showing messages
final accountSummaryMessageProvider = StateProvider<String?>((ref) => null);

final accountSummaryProvider = FutureProvider<AccountSummary>((ref) async {
  final session = await Amplify.Auth.fetchAuthSession();
  if (session is CognitoAuthSession) {
    final idToken = session.userPoolTokensResult.value.idToken.raw;
    const apiUrl = 'http://192.168.1.10:8080/transactions/summary';

    debugPrint("🏦 Fetching Account Summary from API Gateway");
    debugPrint("🔑 Token: ${idToken.isNotEmpty ? 'Present' : 'Missing'}");
    debugPrint("🌐 API URL: $apiUrl");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("✅ API Gateway Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("📦 Account Summary Response: ${response.body}");
        final jsonData = json.decode(response.body);
        return AccountSummary.fromJson(jsonData);
      } else if (response.statusCode == 204) {
        debugPrint("📭 No account summary data found (204)");
        // Set message for UI to show
        ref.read(accountSummaryMessageProvider.notifier).state =
            "No account data found. Start by adding some transactions!";
        // Return a default empty summary
        return AccountSummary(
          month: '',
          income: 0.0,
          expense: 0.0,
          currentBalance: 0.0,
          currencyCode: 'USD',
        );
      } else {
        debugPrint("❌ API Gateway Error: ${response.statusCode}");
        debugPrint("📄 Error Body: ${response.body}");
        throw Exception(
            'Failed to load account summary: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🌐 API Gateway Error Details: $e');
      debugPrint('🔍 Error Type: ${e.runtimeType}');

      // Check for specific network issues with API Gateway
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection failed')) {
        debugPrint(
            '🚨 API Gateway Connection Failed - Check network security config');
        throw Exception(
            'Network error: Cannot connect to API Gateway. Check your internet connection.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Connection timeout: API Gateway request timed out.');
      } else {
        throw Exception('Error fetching account summary: $e');
      }
    }
  } else {
    debugPrint("Not a Cognito session, cannot fetch token.");
    throw Exception('Not a Cognito session, cannot fetch token.');
  }
});
