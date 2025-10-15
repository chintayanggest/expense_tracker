import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recurring_payment_model.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});

  @override
  State<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends State<RecurringScreen> {
  // --- TEMPORARY MOCK DATA using our new Model ---
  final List<RecurringPayment> _recurringPayments = [
    RecurringPayment(
      id: '1',
      name: 'Netflix',
      amount: 65000,
      category: 'Entertainment',
      frequency: 'Monthly',
      nextPaymentDate: DateTime(2025, 11, 1),
    ),
    RecurringPayment(
      id: '2',
      name: 'Spotify',
      amount: 25000,
      category: 'Music',
      frequency: 'Monthly',
      nextPaymentDate: DateTime(2025, 10, 30),
    ),
  ];

  // This is the placeholder dialog your friend made. We will keep it exactly the same.
  void _showAddRecurringDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add Recurring Payment", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Form input will be added in a future step."), // Using English for consistency
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('d MMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // A light grey background
      appBar: AppBar(
        title: const Text(
          "Recurring Payments",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: _recurringPayments.isEmpty
          ? const Center(
        child: Text(
          'No recurring payments yet.\nTap + to add one!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _recurringPayments.length,
        itemBuilder: (context, index) {
          final item = _recurringPayments[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Colors.teal[100],
                child: const Icon(Icons.sync, color: Colors.teal),
              ),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              subtitle: Text(
                '${item.category} • ${item.frequency}\nNext: ${formatDate.format(item.nextPaymentDate)}',
                style: const TextStyle(height: 1.4),
              ),
              trailing: Text(
                formatCurrency.format(item.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRecurringDialog(context);
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}