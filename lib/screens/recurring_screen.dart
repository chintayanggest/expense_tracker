import 'package:flutter/material.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});

  @override
  State<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends State<RecurringScreen> {
  final List<Map<String, dynamic>> recurringList = [
    {
      'name': 'Netflix',
      'amount': 65.000,
      'category': 'Entertainment',
      'frequency': 'Monthly',
      'nextDate': '2025-11-01'
    },
    {
      'name': 'Spotify',
      'amount': 25.000,
      'category': 'Music',
      'frequency': 'Monthly',
      'nextDate': '2025-10-30'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F2),
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: const Text(
          "Recurring Payments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: recurringList.isEmpty
            ? const Center(
          child: Text(
            "No recurring payments yet.\nTap + to add one!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: recurringList.length,
          itemBuilder: (context, index) {
            final item = recurringList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: const Icon(Icons.repeat, color: Colors.green),
                ),
                title: Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "${item['category']} • ${item['frequency']}\nNext: ${item['nextDate']}",
                  style: const TextStyle(height: 1.3),
                ),
                trailing: Text(
                  "Rp ${item['amount'].toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showAddRecurringDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddRecurringDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Add Recurring Payment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Form input akan ditambahkan di tahap berikutnya."),
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
}
