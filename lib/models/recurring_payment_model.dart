class RecurringPayment {
  final String id;
  final String name;
  final double amount;
  final String category;
  final String frequency;
  final DateTime nextPaymentDate;

  RecurringPayment({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.frequency,
    required this.nextPaymentDate,
  });
}