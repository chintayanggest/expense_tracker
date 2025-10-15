import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/transaction_category.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../providers/transaction_provider.dart';
import 'dart:math';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  late TabController _tabController;
  TransactionCategory? _selectedCategory;
  Account? _selectedAccount; // Variable to hold the selected account
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() { _selectedCategory = null; });
    });
    // Set a default account when the screen loads.
    final accounts = Provider.of<TransactionProvider>(context, listen: false).accounts;
    if (accounts.isNotEmpty) {
      _selectedAccount = accounts.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() { _selectedDate = picked; });
    }
  }

  void _saveTransaction() {
    // Updated validation to include account
    if (_amountController.text.isEmpty || _selectedCategory == null || _selectedAccount == null) { return; }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) { return; }

    final transactionType = _tabController.index == 0 ? TransactionType.expense : TransactionType.income;

    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      amount: amount,
      type: transactionType,
      category: _selectedCategory!,
      account: _selectedAccount!, // This line fixes the error
      date: _selectedDate,
      notes: _notesController.text,
    );
    Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        bottom: TabBar( controller: _tabController, tabs: const [ Tab(text: 'Expense'), Tab(text: 'Income'), ], ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionForm(context, TransactionType.expense),
          _buildTransactionForm(context, TransactionType.income),
        ],
      ),
    );
  }

  Widget _buildTransactionForm(BuildContext context, TransactionType type) {
    // We get the provider once to avoid multiple calls
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final categories = provider.getCategoriesByType(type);
    final accounts = provider.accounts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField( controller: _amountController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration( labelText: 'Amount', border: OutlineInputBorder(), ), ),
          const SizedBox(height: 16),

          // NEW WIDGET: ACCOUNT DROPDOWN
          DropdownButtonFormField<Account>(
            value: _selectedAccount,
            hint: const Text('Select Account'),
            items: accounts.map((account) {
              return DropdownMenuItem<Account>(
                value: account,
                child: Row(
                  children: [
                    Icon(account.icon, size: 20),
                    const SizedBox(width: 8),
                    Text(account.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (Account? newValue) {
              setState(() {
                _selectedAccount = newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Account',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8, ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory?.id == category.id;
              return GestureDetector(
                onTap: () { setState(() { _selectedCategory = category; }); },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? category.color.withOpacity(0.4) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: category.color, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category.icon, color: category.color),
                      const SizedBox(height: 4),
                      Text(category.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0])),
              IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _selectDate(context)),
            ],
          ),
          const SizedBox(height: 16),

          TextField( controller: _notesController, decoration: const InputDecoration(labelText: 'Notes (Optional)', border: OutlineInputBorder()), ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _saveTransaction,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Save Transaction'),
          ),
        ],
      ),
    );
  }
}