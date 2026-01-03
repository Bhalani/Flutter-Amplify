import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/sync_provider.dart';
import '../provider/account_summary_provider.dart';
import 'package:amplify_auth/main.dart';
import '../../../core/services/deep_link_service.dart';

import '../../../core/constants/ui_constants.dart';
import '../provider/transaction_provider.dart';
import 'account_summary_card.dart';
import 'transaction_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 17) return 'Good afternoon!';
    return 'Good evening!';
  }

  void _handleDeepLinkCallback(BuildContext context, WidgetRef ref,
      String event, Map<String, dynamic>? data) {
    switch (event) {
      case 'tink-callback-success':
        final userId = data?['userId'];
        final accountId = data?['accountId'];
        final transactionCount = data?['transactionCount'] ?? 0;

        if (transactionCount == 0) {
          // Account freshly connected, no transactions yet
          String message = '🎉 Bank account connected successfully!\n'
              'Your account looks freshly connected. Let\'s wait for transaction records to appear.';
          if (userId != null) {
            message += ' (User: $userId)';
          }
          if (accountId != null) {
            message += ' (Account: $accountId)';
          }

          showGentleSnackBar(context, message, type: SnackBarType.success);
        } else {
          // Account has transactions, show success and refresh data
          String message = '🎉 Bank sync completed successfully!';
          if (transactionCount > 0) {
            message += ' Found $transactionCount transactions.';
          }
          if (userId != null) {
            message += ' (User: $userId)';
          }
          if (accountId != null) {
            message += ' (Account: $accountId)';
          }

          showGentleSnackBar(context, message, type: SnackBarType.success);

          // Refresh data after successful sync with transactions
          ref.invalidate(accountSummaryProvider);
          ref.invalidate(transactionProvider);
        }
        break;

      case 'tink-callback-error':
        final error =
            data?['error'] ?? data?['message'] ?? 'Unknown error occurred';
        showGentleSnackBar(context, '❌ Bank sync failed: $error',
            type: SnackBarType.error);
        break;

      case 'tink-callback-cancelled':
        showGentleSnackBar(context, '⚠️ Bank sync was cancelled',
            type: SnackBarType.info);
        break;

      default:
        debugPrint('Unknown deep link event: $event');
        showGentleSnackBar(context, 'Bank sync completed with unknown status',
            type: SnackBarType.info);
    }

    // Clear the deep link event and data
    ref.read(DeepLinkService.deepLinkProvider.notifier).state = null;
    ref.read(DeepLinkService.callbackDataProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(accountSummaryProvider);
    final ValueNotifier<bool> refreshed = ValueNotifier(false);

    // Watch for messages from both providers
    final accountMessage = ref.watch(accountSummaryMessageProvider);
    final transactionMessage = ref.watch(transactionMessageProvider);

    // Watch for deep link events (Tink callback)
    final deepLinkEvent = ref.watch(DeepLinkService.deepLinkProvider);
    final callbackData = ref.watch(DeepLinkService.callbackDataProvider);

    // Show snackbar if there's a message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (accountMessage != null) {
        showGentleSnackBar(context, accountMessage, type: SnackBarType.info);
        ref.read(accountSummaryMessageProvider.notifier).state =
            null; // Clear message
      }
      if (transactionMessage != null) {
        showGentleSnackBar(context, transactionMessage,
            type: SnackBarType.info);
        ref.read(transactionMessageProvider.notifier).state =
            null; // Clear message
      }

      // Handle different Tink callback scenarios
      if (deepLinkEvent != null) {
        _handleDeepLinkCallback(context, ref, deepLinkEvent, callbackData);
      }
    });
    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (summary) {
        if (summary.hasData) {
          String formattedMonth = summary.month;
          try {
            final parts = summary.month.split('-');
            if (parts.length == 2) {
              final year = parts[0];
              final monthNum = int.tryParse(parts[1]) ?? 1;
              final monthName = [
                '',
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ][monthNum];
              formattedMonth = '$monthName $year';
            }
          } catch (_) {}
          return SafeArea(
            child: Container(
              color: UIConstants.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spaceMd, // 16dp standardized
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(accountSummaryProvider);
                    ref.invalidate(transactionProvider);
                    await Future.delayed(const Duration(milliseconds: 500));
                    refreshed.value = true;
                    await Future.delayed(const Duration(milliseconds: 700));
                    refreshed.value = false;
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personalized Greeting
                        Padding(
                          padding: const EdgeInsets.only(
                            top: UIConstants.spaceLg,
                            bottom: UIConstants.spaceSm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: TextStyle(
                                  fontSize: UIConstants.headerTextSize,
                                  fontWeight: FontWeight.w700,
                                  color: UIConstants.blackColor,
                                ),
                              ),
                              const SizedBox(height: UIConstants.spaceXs),
                              Text(
                                'Your financial overview',
                                style: TextStyle(
                                  fontSize: UIConstants.normalTextSize,
                                  color: UIConstants.mutedColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: UIConstants.spaceMd), // 16dp

                        // Account Summary (Hero Balance)
                        AccountSummaryCard(
                          balance: summary.currentBalance,
                          currencyCode: summary.currencyCode,
                          income: summary.income,
                          expense: summary.expense,
                          formattedMonth: formattedMonth,
                        ),

                        const SizedBox(height: UIConstants.spaceLg), // 24dp

                        // Transactions Section
                        const TransactionList(),

                        // Refresh indicator feedback
                        ValueListenableBuilder<bool>(
                          valueListenable: refreshed,
                          builder: (context, value, child) {
                            return value
                                ? Center(
                                    child: AnimatedOpacity(
                                      opacity: value ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: Icon(Icons.check_circle,
                                          color: UIConstants.successColor,
                                          size: 32),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),

                        const SizedBox(
                            height: UIConstants.spaceLg), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'No account data found for this month.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final url = await ref.read(syncUrlProvider.future);
                    if (url != null) {
                      final uri = Uri.parse(url);
                      try {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error launching URL: $e')),
                          );
                        }
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Failed to get sync URL from backend.')),
                        );
                      }
                    }
                  },
                  child: const Text('Sync with Tink'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
