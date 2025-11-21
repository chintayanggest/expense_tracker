import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/recurring_payment_model.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});

  @override
  State<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends State<RecurringScreen> {
  final List<RecurringPayment> _recurringPayments = []; // Start with empty list for initial empty state

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  String? _editingId;
  String? _selectedCategory;

  // Predefined categories for recurring/subscription payments
  final List<String> _categories = [
    'Entertainment',
    'Music',
    'Utilities',
    'Insurance',
    'Subscription',
    'Food',
    'Transportation',
    'Health',
    'Education',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showRecurringForm({RecurringPayment? payment}) {
    DateTime? tempDate;
    String tempFrequency = 'Monthly';
    String? tempCategory;

    if (payment != null) {
      _editingId = payment.id;
      _nameController.text = payment.name;
      _amountController.text = payment.amount.toString();
      tempCategory = payment.category;
      tempFrequency = payment.frequency;
      tempDate = payment.nextPaymentDate;
    } else {
      _editingId = null;
      _nameController.clear();
      _amountController.clear();
      tempCategory = null;
      tempFrequency = 'Monthly';
      tempDate = null;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: const Color(0xFFF9F9F9),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6FF00),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _editingId == null ? Icons.add_circle_outline : Icons.edit_outlined,
                      color: const Color(0xFF121212),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _editingId == null ? 'Add Recurring Payment' : 'Edit Recurring Payment',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF121212),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Payment Name',
                          labelStyle: const TextStyle(color: Color(0xFF121212)),
                          prefixIcon: const Icon(Icons.subscriptions_outlined, color: Color(0xFF121212)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF9F9F9), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC6FF00), width: 2),
                          ),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Enter payment name' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount (Rp)',
                          labelStyle: const TextStyle(color: Color(0xFF121212)),
                          prefixIcon: const Icon(Icons.payments_outlined, color: Color(0xFF121212)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF9F9F9), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC6FF00), width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (val) => val == null || val.isEmpty ? 'Enter amount' : null,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: tempCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: const TextStyle(color: Color(0xFF121212)),
                          prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF121212)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF9F9F9), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC6FF00), width: 2),
                          ),
                        ),
                        items: _categories.map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        )).toList(),
                        onChanged: (val) {
                          setStateDialog(() {
                            tempCategory = val;
                          });
                        },
                        validator: (val) => val == null ? 'Select a category' : null,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: tempFrequency,
                        decoration: InputDecoration(
                          labelText: 'Frequency',
                          labelStyle: const TextStyle(color: Color(0xFF121212)),
                          prefixIcon: const Icon(Icons.repeat_outlined, color: Color(0xFF121212)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF9F9F9), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC6FF00), width: 2),
                          ),
                        ),
                        items: ['Monthly', 'Weekly'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                        onChanged: (val) {
                          setStateDialog(() {
                            tempFrequency = val!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF9F9F9), width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Color(0xFF121212), size: 20),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Next Payment Date',
                                    style: TextStyle(
                                      color: Color(0xFF121212),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      tempDate == null ? 'Not selected' : DateFormat('d MMM yyyy').format(tempDate!),
                                      style: TextStyle(
                                        color: tempDate == null ? Colors.grey.shade600 : const Color(0xFF121212),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF121212),
                                    foregroundColor: const Color(0xFFC6FF00),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: tempDate ?? now,
                                      firstDate: now,
                                      lastDate: DateTime(2030),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.light(
                                              primary: Color(0xFF121212),
                                              onPrimary: Color(0xFFC6FF00),
                                              onSurface: Color(0xFF121212),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) {
                                      setStateDialog(() {
                                        tempDate = picked;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Select',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _editingId = null;
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF121212),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF121212),
                    foregroundColor: const Color(0xFFC6FF00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (tempDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a date first!'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      final isEditing = _editingId != null;

                      setState(() {
                        if (_editingId == null) {
                          _recurringPayments.insert(
                            0,
                            RecurringPayment(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: _nameController.text,
                              amount: int.parse(_amountController.text),
                              category: tempCategory ?? 'Other',
                              frequency: tempFrequency,
                              nextPaymentDate: tempDate,
                            ),
                          );
                        } else {
                          final idx = _recurringPayments.indexWhere((it) => it.id == _editingId);
                          if (idx != -1) {
                            _recurringPayments[idx] = RecurringPayment(
                              id: _editingId!,
                              name: _nameController.text,
                              amount: int.parse(_amountController.text),
                              category: tempCategory ?? 'Other',
                              frequency: tempFrequency,
                              nextPaymentDate: tempDate,
                            );
                          }
                        }
                        _editingId = null;
                      });

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEditing ? 'Recurring payment updated successfully!' : 'Recurring payment added successfully!'),
                          backgroundColor: const Color(0xFF121212),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Text(
                    _editingId == null ? 'Add' : 'Save',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showOptionsBottomSheet(RecurringPayment payment, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_outlined, color: Color(0xFF121212)),
                ),
                title: const Text(
                  'Edit Payment',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF121212)),
                ),
                subtitle: const Text('Modify payment details'),
                onTap: () {
                  Navigator.pop(context);
                  _showRecurringForm(payment: payment);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.refresh_outlined, color: Color(0xFF121212)),
                ),
                title: const Text(
                  'Simulate Next Payment',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF121212)),
                ),
                subtitle: const Text('Jump to next payment date'),
                onTap: () {
                  Navigator.pop(context);
                  _simulateNextPayment(index);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                title: const Text(
                  'Delete Payment',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                ),
                subtitle: const Text('Remove this payment'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(payment.id);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Delete Payment?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('Are you sure you want to delete this recurring payment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF121212))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _deleteRecurring(id);
              },
              child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  void _deleteRecurring(String id) {
    setState(() => _recurringPayments.removeWhere((item) => item.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recurring payment deleted successfully'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _simulateNextPayment(int index) {
    final item = _recurringPayments[index];

    if (item.nextPaymentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment date not set!')),
      );
      return;
    }

    setState(() {
      final currentDate = item.nextPaymentDate!;
      final newDate = item.frequency == 'Monthly'
          ? DateTime(currentDate.year, currentDate.month + 1, currentDate.day)
          : currentDate.add(const Duration(days: 7));

      _recurringPayments[index] = RecurringPayment(
        id: item.id,
        name: item.name,
        amount: item.amount,
        category: item.category,
        frequency: item.frequency,
        nextPaymentDate: newDate,
      );
    });

    final item2 = _recurringPayments[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Date simulated to ${DateFormat('d MMM yyyy').format(item2.nextPaymentDate!)}"),
        backgroundColor: const Color(0xFF121212),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('d MMM yyyy');
    final total = _recurringPayments.fold<int>(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Recurring Payments",
          style: TextStyle(
            color: Color(0xFFC6FF00),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFC6FF00),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC6FF00).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xFFC6FF00),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Monthly Total",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF121212),
                            ),
                          ),
                          Text(
                            "All recurring payments",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF121212),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatCurrency.format(total),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFC6FF00),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Payment List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC6FF00),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_recurringPayments.length} items',
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _recurringPayments.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6FF00).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      size: 80,
                      color: Color(0xFF121212),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No recurring payments yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF121212),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add one',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100, left: 20, right: 20, top: 8),
              itemCount: _recurringPayments.length,
              itemBuilder: (context, index) {
                final item = _recurringPayments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _showOptionsBottomSheet(item, index),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC6FF00),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF121212),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F9F9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF121212),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '• ${item.frequency}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule_outlined, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.nextPaymentDate != null ? formatDate.format(item.nextPaymentDate!) : "Not set",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency.format(item.amount),
                                  style: const TextStyle(
                                    color: Color(0xFF121212),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC6FF00).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Details',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF121212),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRecurringForm(),
        backgroundColor: const Color(0xFFC6FF00),
        elevation: 8,
        icon: const Icon(Icons.add, color: Color(0xFF121212)),
        label: const Text(
          'Add',
          style: TextStyle(
            color: Color(0xFF121212),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}