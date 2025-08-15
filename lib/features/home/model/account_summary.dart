class AccountSummary {
  final String month;
  final double income;
  final double expense;
  final double currentBalance;
  final String currencyCode;

  AccountSummary({
    required this.month,
    required this.income,
    required this.expense,
    required this.currentBalance,
    required this.currencyCode,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    return AccountSummary(
      month: json['month'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      expense: (json['expense'] ?? 0).toDouble(),
      currentBalance: (json['current_balance'] ?? 0).toDouble(),
      currencyCode: json['currency_code'] ?? '',
    );
  }

  bool get hasData =>
      month.isNotEmpty &&
      income != 0 &&
      expense != 0 &&
      currentBalance != 0 &&
      currencyCode.isNotEmpty;
}
