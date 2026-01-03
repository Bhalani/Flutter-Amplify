import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../model/transaction.dart';

// Provider for showing messages
final transactionMessageProvider = StateProvider<String?>((ref) => null);

final transactionProvider = FutureProvider<List<Transaction>>((ref) async {
  final session = await Amplify.Auth.fetchAuthSession();
  if (session is CognitoAuthSession) {
    final idToken = session.userPoolTokensResult.value.idToken.raw;
    debugPrint("Fetching transactions with authentication token");

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.10:8080/transactions'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Transactions fetched successfully");
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Transaction.fromJson(e)).toList();
      } else if (response.statusCode == 204) {
        debugPrint("No transactions found");
        // Set message for UI to show
        ref.read(transactionMessageProvider.notifier).state =
            "No transactions found. Start adding some transactions!";
        return [];
      } else {
        debugPrint(
            "Failed to fetch transactions. Status code: ${response.statusCode}");
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      throw Exception('Error fetching transactions: $e');
    }
  } else {
    debugPrint("Not a Cognito session, cannot fetch token.");
    throw Exception('Not a Cognito session, cannot fetch token.');
  }
});
