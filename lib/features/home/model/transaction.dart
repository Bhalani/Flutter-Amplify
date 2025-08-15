class Transaction {
  final String id;
  final String date;
  final String merchant;
  final double amount;
  final String currency;
  final String type;
  final String status;

  Transaction({
    required this.id,
    required this.date,
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.type,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      merchant: json['merchant']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
