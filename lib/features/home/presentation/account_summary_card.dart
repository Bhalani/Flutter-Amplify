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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: UIConstants.primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet,
                      color: UIConstants.secondaryColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Current balance',
                    style: TextStyle(
                      fontSize: UIConstants.mediumTextSize,
                      fontWeight: FontWeight.w600,
                      color: UIConstants.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                UIConstants.getCurrencySymbol(currencyCode) +
                    ' ' +
                    balance.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: UIConstants.headerTextSize,
                  fontWeight: FontWeight.bold,
                  color: UIConstants.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today,
                color: UIConstants.slateGreyColor, size: 16),
            const SizedBox(width: 6),
            Text(
              formattedMonth,
              style: TextStyle(
                fontSize: UIConstants.normalTextSize,
                color: UIConstants.slateGreyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: UIConstants.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: UIConstants.borderLightGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Income',
                            style: TextStyle(
                              fontSize: UIConstants.normalTextSize,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(width: 8),
                        Icon(Icons.trending_up,
                            color: UIConstants.primaryColor, size: 22),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      UIConstants.getCurrencySymbol(currencyCode) +
                          ' ' +
                          income.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: UIConstants.subHeaderTextSize,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: UIConstants.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: UIConstants.borderLightGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Expense',
                            style: TextStyle(
                              fontSize: UIConstants.normalTextSize,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(width: 8),
                        Icon(Icons.trending_down, color: Colors.red, size: 22),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      UIConstants.getCurrencySymbol(currencyCode) +
                          ' ' +
                          expense.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: UIConstants.subHeaderTextSize,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
