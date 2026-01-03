import 'package:flutter/material.dart';
import '../../../core/constants/ui_constants.dart';

class AccountSummaryCard extends StatelessWidget {
  final double balance;
  final String currencyCode;
  final double income;
  final double expense;
  final String formattedMonth;

  const AccountSummaryCard({
    required this.balance,
    required this.currencyCode,
    required this.income,
    required this.expense,
    required this.formattedMonth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = UIConstants.getCurrencySymbol(currencyCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Balance Card with integrated month
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(UIConstants.spaceLg), // 24dp
          decoration: BoxDecoration(
            gradient: UIConstants.primaryGradient,
            borderRadius: UIConstants.borderRadiusLg,
            boxShadow: UIConstants.primaryShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month badge (integrated into card)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.spaceSm,
                  vertical: UIConstants.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: UIConstants.borderRadiusSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 12,
                    ),
                    const SizedBox(width: UIConstants.spaceXs),
                    Text(
                      formattedMonth,
                      style: TextStyle(
                        fontSize: UIConstants.smallTextSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: UIConstants.spaceMd), // 16dp

              // Label
              Text(
                'Current Balance',
                style: TextStyle(
                  fontSize: UIConstants.normalTextSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: UIConstants.spaceXs), // 4dp

              // Hero Balance Amount
              Text(
                '$currencySymbol ${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 36, // Larger for hero effect
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: UIConstants.spaceMd), // 16dp

        // Income & Expense Cards Row
        Row(
          children: [
            // Income Card
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_up_rounded,
                label: 'Income',
                amount: income,
                currencySymbol: currencySymbol,
                color: UIConstants.successColor,
                isPositive: true,
              ),
            ),

            const SizedBox(width: UIConstants.spaceMd), // 16dp

            // Expense Card
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_down_rounded,
                label: 'Expense',
                amount: expense,
                currencySymbol: currencySymbol,
                color: UIConstants.dangerColor,
                isPositive: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required double amount,
    required String currencySymbol,
    required Color color,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spaceMd), // 16dp
      decoration: BoxDecoration(
        color: UIConstants.surfaceColor,
        borderRadius: UIConstants.borderRadiusLg,
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: UIConstants.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and label
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: UIConstants.borderRadiusSm,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: UIConstants.spaceSm),
              Text(
                label,
                style: TextStyle(
                  fontSize: UIConstants.normalTextSize,
                  fontWeight: FontWeight.w600,
                  color: UIConstants.slateGreyColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: UIConstants.spaceSm), // 8dp

          // Amount with sign indicator
          Text(
            '${isPositive ? '+' : '-'}$currencySymbol ${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: UIConstants.subHeaderTextSize,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
