import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/transaction_category.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];

  final List<Account> _accounts = [
    Account(id: 'a1', name: 'Wallet', icon: Icons.account_balance_wallet),
  ];

  final List<TransactionCategory> _categories = [
    // Default Expense Categories
    TransactionCategory(id: 'c1', name: 'Food', icon: Icons.fastfood, color: Colors.red, type: TransactionType.expense),
    TransactionCategory(id: 'c2', name: 'Transport', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    TransactionCategory(id: 'c3', name: 'Groceries', icon: Icons.shopping_cart, color: Colors.green, type: TransactionType.expense),
    TransactionCategory(id: 'c4', name: 'Entertainment', icon: Icons.movie, color: Colors.purple, type: TransactionType.expense),
    // Default Income Categories
    TransactionCategory(id: 'c5', name: 'Salary', icon: Icons.work, color: Colors.green, type: TransactionType.income),
    TransactionCategory(id: 'c6', name: 'Gifts', icon: Icons.card_giftcard, color: Colors.orange, type: TransactionType.income),
  ];

  // --- GETTERS ---
  List<Transaction> get transactions => _transactions;
  List<TransactionCategory> get categories => _categories;
  List<Account> get accounts => _accounts;

  // THIS IS THE CORRECTED METHOD
  List<TransactionCategory> getCategoriesByType(TransactionType type) {
    return _categories.where((category) => category.type == type).toList();
  }

  // --- COMPUTED GETTERS (CORRECTED) ---
  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  // --- METHODS ---
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);

    // Update account balance
    final account = _accounts.firstWhere((acc) => acc.id == transaction.account.id);
    if (transaction.type == TransactionType.income) {
      account.balance += transaction.amount;
    } else {
      account.balance -= transaction.amount;
    }
    notifyListeners();
  }

  void addCategory(TransactionCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }
}