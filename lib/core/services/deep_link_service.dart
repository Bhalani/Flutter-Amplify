import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();

  // Provider for deep link events
  static final deepLinkProvider = StateProvider<String?>((ref) => null);

  // Provider for callback data
  static final callbackDataProvider =
      StateProvider<Map<String, dynamic>?>((ref) => null);

  static void initialize(WidgetRef ref) {
    // Listen for deep links when app is already running
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('Deep link received: $uri');
      _handleDeepLink(uri, ref);
    }).onError((err) {
      debugPrint('Deep link error: $err');
    });

    // Check for initial deep link when app is launched
    _checkInitialLink(ref);
  }

  static Future<void> _checkInitialLink(WidgetRef ref) async {
    try {
      final Uri? initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        _handleDeepLink(initialUri, ref);
      }
    } catch (e) {
      debugPrint('Error checking initial deep link: $e');
    }
  }

  static void _handleDeepLink(Uri uri, WidgetRef ref) {
    debugPrint('Processing deep link: $uri');

    if (uri.scheme == 'treuewert') {
      switch (uri.host) {
        case 'tink-callback':
          _handleTinkCallback(uri, ref);
          break;
        default:
          debugPrint('Unknown deep link host: ${uri.host}');
      }
    }
  }

  static void _handleTinkCallback(Uri uri, WidgetRef ref) {
    debugPrint('🎉 Tink callback received!');
    debugPrint('Callback URI: $uri');

    // Parse query parameters
    final queryParams = uri.queryParameters;
    debugPrint('Tink callback params: $queryParams');

    // Extract common parameters
    final status = queryParams['status'];
    final userId = queryParams['userId'];
    final accountId = queryParams['accountId'];
    final error = queryParams['error'];
    final message = queryParams['message'];
    final transactionCountStr = queryParams['transaction_count'];
    final transactionCount = int.tryParse(transactionCountStr ?? '0') ?? 0;

    // Handle different status scenarios
    String callbackState;
    if (status == 'success') {
      callbackState = 'tink-callback-success';
      debugPrint(
          '✅ Tink sync successful for user: $userId, account: $accountId');
    } else if (status == 'error' || error != null) {
      callbackState = 'tink-callback-error';
      debugPrint('❌ Tink sync failed: ${error ?? message ?? 'Unknown error'}');
    } else if (status == 'cancelled') {
      callbackState = 'tink-callback-cancelled';
      debugPrint('⚠️ Tink sync was cancelled by user');
    } else {
      callbackState = 'tink-callback-unknown';
      debugPrint('❓ Unknown Tink callback status: $status');
    }

    // Store the callback data for the UI to access
    final callbackData = {
      'status': status,
      'userId': userId,
      'accountId': accountId,
      'error': error,
      'message': message,
      'transactionCount': transactionCount,
      'allParams': queryParams,
    };

    // Set the deep link state with the status
    ref.read(deepLinkProvider.notifier).state = callbackState;

    // Store callback data in a separate provider if needed
    ref.read(callbackDataProvider.notifier).state = callbackData;
  }
}
