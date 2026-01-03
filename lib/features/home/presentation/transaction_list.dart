import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/ui_constants.dart';
import '../provider/transaction_provider.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnAsync = ref.watch(transactionProvider);
    return txnAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading transactions: $e')),
      data: (txns) {
        if (txns.isEmpty) {
          return const Center(
              child: Text('No transactions found.',
                  style: TextStyle(fontSize: 16)));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: UIConstants.mediumTextSize,
                      fontWeight: FontWeight.bold,
                      color: UIConstants.slateGreyColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            ...txns.map((txn) {
              final isIncome = txn.type == 'income' || txn.amount > 0;
              // Use txn.type for initials and color
              String type = txn.type;
              // String initials = type.isNotEmpty
              //     ? type
              //         .split(' ')
              //         .map((w) => w[0])
              //         .take(2)
              //         .join()
              //         .toUpperCase()
              //     : 'T';
              Color avatarColor;
              switch (type.toLowerCase()) {
                case 'salary':
                  avatarColor = UIConstants.primaryColor.withOpacity(0.15);
                  break;
                case 'food & dining':
                  avatarColor = Colors.redAccent.withOpacity(0.15);
                  break;
                case 'entertainment':
                  avatarColor = Colors.pinkAccent.withOpacity(0.15);
                  break;
                case 'freelance':
                  avatarColor = Colors.blueAccent.withOpacity(0.15);
                  break;
                case 'utilities':
                  avatarColor = Colors.orangeAccent.withOpacity(0.15);
                  break;
                case 'transportation':
                  avatarColor = Colors.deepPurpleAccent.withOpacity(0.15);
                  break;
                case 'investments':
                  avatarColor = Colors.greenAccent.withOpacity(0.15);
                  break;
                case 'shopping':
                  avatarColor = Colors.red.withOpacity(0.15);
                  break;
                default:
                  avatarColor = UIConstants.slateGreyColor.withOpacity(0.12);
              }
              final amountColor =
                  isIncome ? UIConstants.primaryColor : Colors.red;
              final formattedAmount = (isIncome ? '+' : '-') +
                  UIConstants.getCurrencySymbol(txn.currency) +
                  ' ' +
                  txn.amount.abs().toStringAsFixed(2);
              final statusText =
                  (txn.status == 'booked' || txn.status == 'completed')
                      ? 'completed'
                      : txn.status;
              return Container(
                decoration: BoxDecoration(
                  color: UIConstants.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: UIConstants.slateGreyColor,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: avatarColor,
                        child: Icon(
                          isIncome ? Icons.south_west : Icons.north_east,
                          color:
                              isIncome ? UIConstants.primaryColor : Colors.red,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              txn.merchant,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              (txn.date.isNotEmpty ? txn.date : ''),
                              style: TextStyle(
                                  fontSize: 13,
                                  color: UIConstants.slateGreyColor
                                      .withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formattedAmount,
                                  style: TextStyle(
                                    color: amountColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: UIConstants.slateGreyColor
                                    .withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: UIConstants.slateGreyColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
