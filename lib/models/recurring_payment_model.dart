class RecurringPayment {
  final String id;
  final String name;
  final int amount;
  final String category;
  final String frequency;
  final DateTime? nextPaymentDate; // Ubah jadi nullable

  RecurringPayment({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.frequency,
    this.nextPaymentDate, // Tidak required lagi
  });
}