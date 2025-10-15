import 'transaction_category.dart';
import 'transaction_type.dart';
import 'account.dart'; // ADD THIS NEW IMPORT

class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final Account account; // ADD THIS NEW PROPERTY
  final DateTime date;
  final String? notes;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.account, // ADD THIS TO THE CONSTRUCTOR
    required this.date,
    this.notes,
  });
}