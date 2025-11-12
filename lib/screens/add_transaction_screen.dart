import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/transaction_category.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../providers/transaction_provider.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum DateShortcut { today, yesterday, none }

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transactionToEdit;
  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  late TabController _tabController;
  TransactionCategory? _selectedCategory;
  Account? _selectedAccount;
  DateTime _selectedDate = DateTime.now();
  DateShortcut _selectedDateShortcut = DateShortcut.today;

  final List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.transactionToEdit != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: _isEditing && widget.transactionToEdit!.type == TransactionType.income ? 1 : 0,
        length: 2,
        vsync: this
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() { _selectedCategory = null; });
      }
    });

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    if (_isEditing) {
      final tx = widget.transactionToEdit!;
      _amountController.text = tx.amount.toStringAsFixed(0);
      _selectedDate = tx.date;
      _selectedCategory = tx.category;
      _selectedAccount = provider.accounts.firstWhere((acc) => acc.id == tx.account.id);
      _notesController.text = tx.notes ?? '';
      if (tx.imagePaths != null) {
        for (var path in tx.imagePaths!) {
          _imageFiles.add(XFile(path));
        }
      }
      _selectedDateShortcut = DateShortcut.none;
    } else {
      if (provider.accounts.isNotEmpty) {
        _selectedAccount = provider.accounts.first;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(pickedFile);
        });
      }
    } catch (e) {
      print('Failed to pick image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedDateShortcut = DateShortcut.none;
      });
    }
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) { return; }
    if (_selectedCategory == null || _selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category and account.')));
      return;
    }

    final amount = double.tryParse(_amountController.text)!;
    final transactionType = _tabController.index == 0 ? TransactionType.expense : TransactionType.income;
    final notes = _notesController.text;
    final imagePaths = _imageFiles.map((file) => file.path).toList();

    if (_isEditing) {
      final updatedTransaction = Transaction(
        id: widget.transactionToEdit!.id,
        amount: amount,
        type: transactionType,
        category: _selectedCategory!,
        account: _selectedAccount!,
        date: _selectedDate,
        notes: notes,
        imagePaths: imagePaths.isNotEmpty ? imagePaths : null,
      );
      Provider.of<TransactionProvider>(context, listen: false).updateTransaction(updatedTransaction);
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction updated successfully!'), duration: Duration(seconds: 2), backgroundColor: Colors.green));
    } else {
      final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        amount: amount,
        type: transactionType,
        category: _selectedCategory!,
        account: _selectedAccount!,
        date: _selectedDate,
        notes: notes,
        imagePaths: imagePaths.isNotEmpty ? imagePaths : null,
      );
      Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [ Tab(text: 'Expense'), Tab(text: 'Income'), ],
        ),
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
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final categories = provider.getCategoriesByType(type);
    final accounts = provider.accounts;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration( labelText: 'Amount', border: OutlineInputBorder() ),
              validator: (value) {
                if (value == null || value.isEmpty) { return 'Please enter an amount.'; }
                if (double.tryParse(value) == null) { return 'Please enter a valid number.'; }
                if (double.parse(value) <= 0) { return 'Amount must be greater than zero.'; }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Account>(
              value: _selectedAccount,
              hint: const Text('Select Account'),
              items: accounts.map((account) {
                return DropdownMenuItem<Account>(
                  value: account,
                  child: Row(children: [ Icon(account.icon, size: 20), const SizedBox(width: 8), Text(account.name) ]),
                );
              }).toList(),
              onChanged: (Account? newValue) { setState(() { _selectedAccount = newValue; }); },
              decoration: const InputDecoration( labelText: 'Account', border: OutlineInputBorder() ),
            ),
            const SizedBox(height: 16),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8 ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.bold))),
                    IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _selectDate(context)),
                  ],
                ),
                Row(
                  children: [
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(backgroundColor: _selectedDateShortcut == DateShortcut.today ? Theme.of(context).primaryColor.withOpacity(0.3) : null),
                      child: const Text('Today'),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime.now();
                          _selectedDateShortcut = DateShortcut.today;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(backgroundColor: _selectedDateShortcut == DateShortcut.yesterday ? Theme.of(context).primaryColor.withOpacity(0.3) : null),
                      child: const Text('Yesterday'),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime.now().subtract(const Duration(days: 1));
                          _selectedDateShortcut = DateShortcut.yesterday;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField( controller: _notesController, decoration: const InputDecoration(labelText: 'Notes (Optional)', border: OutlineInputBorder()) ),
            const SizedBox(height: 24),
            const Text('Photos', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceActionSheet(context),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(File(_imageFiles[index].path), width: 100, height: 100, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () { setState(() { _imageFiles.removeAt(index); }); },
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}