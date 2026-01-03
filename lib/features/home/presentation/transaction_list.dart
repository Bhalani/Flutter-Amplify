import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/ui_constants.dart';
import '../provider/transaction_provider.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key});

  Color _getTypeColor(String type, bool isIncome) {
    if (isIncome) return UIConstants.accentColor;

    switch (type.toLowerCase()) {
      case 'food & dining':
        return const Color(0xFFEF4444);
      case 'entertainment':
        return const Color(0xFFEC4899);
      case 'utilities':
        return const Color(0xFFF97316);
      case 'transportation':
        return const Color(0xFF8B5CF6);
      case 'shopping':
        return const Color(0xFFEF4444);
      case 'investments':
        return const Color(0xFF22C55E);
      default:
        return UIConstants.slateGreyColor;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnAsync = ref.watch(transactionProvider);
    return txnAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(UIConstants.spaceLg),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(
        child: Text(
          'Error loading transactions: $e',
          style: UIConstants.bodyStyle,
        ),
      ),
      data: (txns) {
        if (txns.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: UIConstants.mutedColor,
                ),
                const SizedBox(height: UIConstants.spaceMd),
                Text(
                  'No transactions found',
                  style: UIConstants.bodyStyle.copyWith(
                    color: UIConstants.mutedColor,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: UIConstants.titleStyle,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.spaceMd,
                      vertical: UIConstants.spaceSm,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: UIConstants.smallTextSize,
                          fontWeight: FontWeight.w600,
                          color: UIConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: UIConstants.spaceXs),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: UIConstants.primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: UIConstants.spaceMd),

            // Transaction Items
            ...txns.asMap().entries.map((entry) {
              final index = entry.key;
              final txn = entry.value;
              final isIncome = txn.type == 'income' || txn.amount > 0;
              final typeColor = _getTypeColor(txn.type, isIncome);

              final amountColor =
                  isIncome ? UIConstants.accentColor : UIConstants.dangerColor;
              final formattedAmount =
                  '${isIncome ? '+' : '-'}${UIConstants.getCurrencySymbol(txn.currency)} ${txn.amount.abs().toStringAsFixed(2)}';
              final statusText = (txn.status == 'booked' ||
                      txn.status == 'completed')
                  ? 'Completed'
                  : txn.status.isNotEmpty
                      ? txn.status[0].toUpperCase() + txn.status.substring(1)
                      : 'Pending';

              return Container(
                margin: EdgeInsets.only(
                  bottom: index < txns.length - 1 ? UIConstants.spaceXs : 0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spaceSm,
                  vertical: UIConstants.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: UIConstants.surfaceColor,
                  borderRadius: UIConstants.borderRadiusSm,
                  boxShadow: UIConstants.shadowSm,
                ),
                child: Row(
                  children: [
                    // Transaction Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: UIConstants.borderRadiusSm,
                      ),
                      child: Icon(
                        isIncome
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                        color: typeColor,
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: UIConstants.spaceMd),

                    // Transaction Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            txn.merchant,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: UIConstants.mediumTextSize,
                              color: UIConstants.blackColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: UIConstants.spaceXs),
                          Text(
                            txn.date.isNotEmpty ? txn.date : 'No date',
                            style: TextStyle(
                              fontSize: UIConstants.smallTextSize,
                              color: UIConstants.mutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount & Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formattedAmount,
                          style: TextStyle(
                            color: amountColor,
                            fontWeight: FontWeight.w700,
                            fontSize: UIConstants.mediumTextSize,
                          ),
                        ),
                        const SizedBox(height: UIConstants.spaceXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.spaceSm,
                            vertical: UIConstants.spaceXs,
                          ),
                          decoration: BoxDecoration(
                            color: (txn.status.toLowerCase() == 'booked' ||
                                    txn.status.toLowerCase() == 'completed')
                                ? UIConstants.successColor.withOpacity(0.15)
                                : UIConstants.slateGreyColor.withOpacity(0.12),
                            borderRadius: UIConstants.borderRadiusSm,
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: UIConstants.tinyTextSize,
                              color: (txn.status.toLowerCase() == 'booked' ||
                                      txn.status.toLowerCase() == 'completed')
                                  ? UIConstants.successColor
                                  : UIConstants.slateGreyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
