import 'transaction_category.dart';
import 'transaction_type.dart';
import 'account.dart';

class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final Account account;
  final DateTime date;
  final String? notes;
  final List<String>? imagePaths;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.account,
    required this.date,
    this.notes,
    this.imagePaths,
  });
}