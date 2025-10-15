class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
  });

  // Menghitung progress dalam persentase (0.0 - 1.0)
  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0.0;

  // Menghitung sisa amount yang perlu dicapai
  double get remainingAmount => targetAmount - currentAmount;

  // Cek apakah goal sudah tercapai
  bool get isCompleted => currentAmount >= targetAmount;

  // Convert ke Map untuk database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate?.toIso8601String(),
    };
  }

  // Create dari Map (database)
  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'] as String,
      name: map['name'] as String,
      targetAmount: (map['targetAmount'] as num).toDouble(),
      currentAmount: (map['currentAmount'] as num).toDouble(),
      targetDate: map['targetDate'] != null
          ? DateTime.parse(map['targetDate'] as String)
          : null,
    );
  }

  // Copy with method untuk update
  SavingsGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
    );
  }
}