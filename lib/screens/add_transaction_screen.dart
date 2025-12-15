//-----------------------------------------------------------
//  ADD TRANSACTION SCREEN — DARK MODE + CATEGORY COLORS
//-----------------------------------------------------------
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/unified_models.dart';
import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transactionToEdit;
  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  late TabController _tabController;

  TransactionCategory? _selectedCategory;
  Account? _selectedAccount;
  DateTime _selectedDate = DateTime.now();

  final List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;
  bool get _isEditing => widget.transactionToEdit != null;

  //-----------------------------------------------------------
  // INIT
  //-----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    int initialIndex = 0;
    if (_isEditing && widget.transactionToEdit!.type == TransactionType.income) {
      initialIndex = 1;
    }

    _tabController = TabController(initialIndex: initialIndex, length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    if (_isEditing) {
      final tx = widget.transactionToEdit!;
      _amountController.text = tx.amount.toStringAsFixed(0);
      _notesController.text = tx.notes ?? '';
      _selectedDate = tx.date;

      if (tx.imagePaths != null) {
        for (var p in tx.imagePaths!) {
          _imageFiles.add(XFile(p));
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<TransactionProvider>(context, listen: false);
        try {
          _selectedAccount = provider.accounts.firstWhere((a) => a.id == tx.account.id);
        } catch (_) {}

        try {
          _selectedCategory = provider.categories.firstWhere((c) => c.id == tx.category.id);
        } catch (_) {}

        setState(() {});
      });

    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<TransactionProvider>(context, listen: false);
        if (provider.accounts.isNotEmpty) {
          setState(() => _selectedAccount = provider.accounts.first);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------
  // IMAGE PICKER
  //-----------------------------------------------------------
  Future<void> _pickImage(ImageSource source) async {
    if (Platform.isAndroid) {
      await Permission.photos.request();
      await Permission.storage.request();
    }

    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _imageFiles.add(picked));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text('Photo Library', style: TextStyle(color: Colors.white)),
                onTap: () => { _pickImage(ImageSource.gallery), Navigator.pop(ctx) },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.white),
                title: const Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () => { _pickImage(ImageSource.camera), Navigator.pop(ctx) },
              ),
            ],
          ),
        );
      },
    );
  }

  //-----------------------------------------------------------
  // DATE PICKER
  //-----------------------------------------------------------
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  //-----------------------------------------------------------
  // SAVE TRANSACTION
  //-----------------------------------------------------------
  Future<void> _saveTransaction() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a Category")),
      );
      return;
    }

    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an Account")),
      );
      return;
    }

    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      final amount = double.parse(_amountController.text.replaceAll(",", ""));

      final transaction = TransactionModel(
        id: _isEditing ? widget.transactionToEdit!.id : const Uuid().v4(),
        userId: user.id,
        amount: amount,
        type: _tabController.index == 0 ? TransactionType.expense : TransactionType.income,
        category: _selectedCategory!,
        account: _selectedAccount!,
        date: _selectedDate,
        notes: _notesController.text,
        imagePaths: _imageFiles.map((e) => e.path).toList(),
      );

      final provider = Provider.of<TransactionProvider>(context, listen: false);

      if (_isEditing) {
        await provider.deleteTransaction(widget.transactionToEdit!.id);
        await provider.addTransaction(transaction);
      } else {
        await provider.addTransaction(transaction);
      }

      if (mounted) Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (mounted) setState(() => _isSaving = false);
  }

  //-----------------------------------------------------------
  // BUILD UI — DARK MODE + CATEGORY COLORS
  //-----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(
          _isEditing ? "Edit Transaction" : "Add Transaction",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),

        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFC6FF00),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFC6FF00),
          tabs: const [
            Tab(text: "Expense"),
            Tab(text: "Income"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForm(TransactionType.expense),
          _buildForm(TransactionType.income),
        ],
      ),
    );
  }

  //-----------------------------------------------------------
  // FORM
  //-----------------------------------------------------------
  Widget _buildForm(TransactionType type) {
    final provider = Provider.of<TransactionProvider>(context);
    final categories = provider.getCategoriesByType(type);
    final accounts = provider.accounts;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            //---------------------------------------------------
            // AMOUNT
            //---------------------------------------------------
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInput("Amount", prefix: "Rp "),
              validator: (v) {
                if (v == null || v.isEmpty) return "Enter amount";
                if (double.tryParse(v.replaceAll(",", "")) == null) return "Invalid number";
                return null;
              },
            ),

            const SizedBox(height: 16),

            //---------------------------------------------------
            // ACCOUNT DROPDOWN
            //---------------------------------------------------
            DropdownButtonFormField<Account>(
              value: _selectedAccount,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: _darkInput("Account"),
              onChanged: (val) => setState(() => _selectedAccount = val),
              items: accounts.map((acc) {
                return DropdownMenuItem(
                  value: acc,
                  child: Text(acc.name, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            //---------------------------------------------------
            // CATEGORY GRID
            //---------------------------------------------------
            const Text("Category",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final selected = _selectedCategory?.id == cat.id;

                // W A R N A   T E M A   K A T E G O R I
                final Color themedColor = cat.name.toLowerCase() == "others"
                    ? const Color(0xFFC6FF00) // khusus others
                    : cat.color; // warna kategori

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? themedColor : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? Border.all(color: themedColor, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat.icon,
                            color: selected ? Colors.black : Colors.white),
                        const SizedBox(height: 4),
                        Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected ? Colors.black : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            //---------------------------------------------------
            // DATE
            //---------------------------------------------------
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Date: ${_selectedDate.toString().split(" ")[0]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _selectDate,
                  child: const Text("Change", style: TextStyle(color: Color(0xFFC6FF00))),
                )
              ],
            ),

            const SizedBox(height: 16),

            //---------------------------------------------------
            // NOTES
            //---------------------------------------------------
            TextField(
              controller: _notesController,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInput("Notes"),
            ),

            const SizedBox(height: 24),

            //---------------------------------------------------
            // PHOTOS
            //---------------------------------------------------
            const Text("Photos",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            SizedBox(
              height: 100,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles.length,
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_imageFiles[i].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _imageFiles.removeAt(i)),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),

            //---------------------------------------------------
            // SAVE BUTTON
            //---------------------------------------------------
            ElevatedButton(
              onPressed: _isSaving ? null : _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _isSaving ? Colors.grey : const Color(0xFFC6FF00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                "Save Transaction",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------
  // INPUT DECORATION DARK MODE
  //-----------------------------------------------------------
  InputDecoration _darkInput(String label, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixText: prefix,
      prefixStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC6FF00), width: 2),
      ),
    );
  }
}
