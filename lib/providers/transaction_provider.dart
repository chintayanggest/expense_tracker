import 'package:flutter/material.dart';
import '../models/account.dart';
import '../models/transaction_category.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];
  final List<Account> _accounts = [
    Account(id: 'a1', name: 'Wallet', icon: Icons.account_balance_wallet),
    Account(id: 'a2', name: 'GoPay', icon: Icons.phone_android),
    Account(id: 'a3', name: 'ShopeePay', icon: Icons.shopping_cart),
    Account(id: 'a4', name: 'DANA', icon: Icons.credit_card),
    Account(id: 'a5', name: 'OVO', icon: Icons.local_offer),
    Account(id: 'a6', name: 'Mobile Banking 1', icon: Icons.account_balance),
    Account(id: 'a7', name: 'Mobile Banking 2', icon: Icons.account_balance),
    Account(id: 'a8', name: 'Mobile Banking 3', icon: Icons.account_balance),
    Account(id: 'a9', name: 'Mobile Banking 4', icon: Icons.account_balance),
    Account(id: 'a10', name: 'Mobile Banking 5', icon: Icons.account_balance),
    Account(id: 'a11', name: 'Cash', icon: Icons.money),
    Account(id: 'a12', name: 'E-Money Card', icon: Icons.payment),
    Account(id: 'a13', name: 'Credit Card', icon: Icons.credit_card_outlined),
    Account(id: 'a14', name: 'Investment', icon: Icons.trending_up),
    Account(id: 'a15', name: 'Savings', icon: Icons.savings),
    Account(id: 'a16', name: 'Other', icon: Icons.more_horiz),
  ];

  final List<TransactionCategory> _categories = [
    // --- 9 Expense Categories ---
    TransactionCategory(id: 'e1', name: 'Food', icon: Icons.fastfood, color: Colors.orange, type: TransactionType.expense),
    TransactionCategory(id: 'e2', name: 'Transport', icon: Icons.directions_car, color: Colors.blue, type: TransactionType.expense),
    TransactionCategory(id: 'e3', name: 'Shopping', icon: Icons.shopping_bag, color: Colors.pink, type: TransactionType.expense),
    TransactionCategory(id: 'e4', name: 'Bills', icon: Icons.receipt, color: Colors.green, type: TransactionType.expense),
    TransactionCategory(id: 'e5', name: 'Health', icon: Icons.healing, color: Colors.red, type: TransactionType.expense),
    TransactionCategory(id: 'e6', name: 'Housing', icon: Icons.house, color: Colors.brown, type: TransactionType.expense),
    TransactionCategory(id: 'e7', name: 'Education', icon: Icons.school, color: Colors.indigo, type: TransactionType.expense),
    TransactionCategory(id: 'e8', name: 'Entertainment', icon: Icons.movie, color: Colors.purple, type: TransactionType.expense),
    TransactionCategory(id: 'e9', name: 'Beauty', icon: Icons.face , color: Colors.pinkAccent , type: TransactionType.expense),
    TransactionCategory(id: 'e10', name: 'Other', icon: Icons.more_horiz, color: Colors.grey, type: TransactionType.expense),

    // --- 9 Income Categories ---
    TransactionCategory(id: 'i1', name: 'Salary', icon: Icons.work, color: Colors.green, type: TransactionType.income),
    TransactionCategory(id: 'i2', name: 'Gifts', icon: Icons.card_giftcard, color: Colors.red, type: TransactionType.income),
    TransactionCategory(id: 'i3', name: 'Investment', icon: Icons.trending_up, color: Colors.blue, type: TransactionType.income),
    TransactionCategory(id: 'i4', name: 'Freelance', icon: Icons.laptop_mac, color: Colors.teal, type: TransactionType.income),
    TransactionCategory(id: 'i5', name: 'Business', icon: Icons.business, color: Colors.cyan, type: TransactionType.income),
    TransactionCategory(id: 'i6', name: 'Rental', icon: Icons.real_estate_agent, color: Colors.amber, type: TransactionType.income),
    TransactionCategory(id: 'i7', name: 'Awards', icon: Icons.emoji_events, color: Colors.yellow, type: TransactionType.income),
    TransactionCategory(id: 'i8', name: 'Grants', icon: Icons.account_balance, color: Colors.lightGreen, type: TransactionType.income),
    TransactionCategory(id: 'i9', name: 'Other', icon: Icons.more_horiz, color: Colors.grey, type: TransactionType.income),
  ];

  // --- GETTERS ---
  List<Transaction> get transactions => _transactions;
  List<TransactionCategory> get categories => _categories;
  List<Account> get accounts => _accounts;
  List<TransactionCategory> getCategoriesByType(TransactionType type) { return _categories.where((c) => c.type == type).toList(); }

  double get totalBalance {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  double get totalIncome { return _transactions.where((tx) => tx.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount); }
  double get totalExpense { return _transactions.where((tx) => tx.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount); }

  // --- METHODS ---
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    // Find the account and update its balance based on the transaction
    final account = _accounts.firstWhere((acc) => acc.id == transaction.account.id);
    if (transaction.type == TransactionType.income) {
      account.balance += transaction.amount;
    } else {
      account.balance -= transaction.amount;
    }
    notifyListeners();
  }

  void deleteTransaction(String transactionId) {
    // Find the transaction to be deleted
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == transactionId);
    if (transactionIndex == -1) return; // Not found

    final transactionToDelete = _transactions[transactionIndex];

    // Reverse the transaction's effect on the account balance
    final account = _accounts.firstWhere((acc) => acc.id == transactionToDelete.account.id);
    if (transactionToDelete.type == TransactionType.income) {
      account.balance -= transactionToDelete.amount;
    } else {
      account.balance += transactionToDelete.amount;
    }

    // Remove the transaction from the list
    _transactions.removeAt(transactionIndex);
    notifyListeners();
  }

  void updateTransaction(Transaction updatedTransaction) {
    // Find the index of the old transaction
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == updatedTransaction.id);
    if (transactionIndex == -1) return; // Not found

    final oldTransaction = _transactions[transactionIndex];

    // Find the associated account
    final account = _accounts.firstWhere((acc) => acc.id == oldTransaction.account.id);

    // Step 1: Undo the old transaction's amount
    if (oldTransaction.type == TransactionType.income) {
      account.balance -= oldTransaction.amount;
    } else {
      account.balance += oldTransaction.amount;
    }
    // Step 2: Apply the new transaction's amount
    if (updatedTransaction.type == TransactionType.income) {
      account.balance += updatedTransaction.amount;
    } else {
      account.balance -= updatedTransaction.amount;
    }

    _transactions[transactionIndex] = updatedTransaction;
    notifyListeners();
  }

  void updateAccount({required String id, required String newName, required double newBalance}) {
    final accountIndex = _accounts.indexWhere((acc) => acc.id == id);
    if (accountIndex != -1) {
      _accounts[accountIndex].name = newName;
      _accounts[accountIndex].balance = newBalance;
      notifyListeners();
    }
  }
}