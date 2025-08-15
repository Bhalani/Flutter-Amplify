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
    debugPrint("\n\n\n\n ID Token: $idToken \n\n\n\n");
    try {
      final response = await http.get(
        Uri.parse(
            'https://rh1k6y8abj.execute-api.ap-south-1.amazonaws.com/dev/transactions/summary'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint("\n\n\n\n=====================");
        debugPrint("Account summary fetched successfully.");
        debugPrint("Response body: ${response.body}");
        debugPrint("=====================\n\n\n\n");
        final jsonData = json.decode(response.body);
        return AccountSummary.fromJson(jsonData);
      } else if (response.statusCode == 204) {
        debugPrint("No account summary data found");
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
        debugPrint(
            "Failed to fetch account summary. Status code: ${response.statusCode}");
        throw Exception('Failed to load account summary');
      }
    } catch (e) {
      debugPrint('\n\n\n\nError fetching account summary: $e\n\n\n\n');
      throw Exception('Error fetching account summary: $e');
    }
  } else {
    debugPrint("Not a Cognito session, cannot fetch token.");
    throw Exception('Not a Cognito session, cannot fetch token.');
  }
});
