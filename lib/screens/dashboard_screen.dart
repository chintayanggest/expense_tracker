import 'package:flutter/material.dart';
import 'package:mobile_course_project/screens/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.blue, size: 40),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Here’s your financial overview.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions Section
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  TransactionTile(
                    icon: Icons.shopping_cart,
                    title: 'Shopping',
                    amount: -150.00,
                    color: Colors.red.withValues(alpha: 0.2),
                  ),
                  TransactionTile(
                    icon: Icons.restaurant,
                    title: 'Dining',
                    amount: -75.50,
                    color: Colors.orange.withValues(alpha: 0.2),
                  ),
                  TransactionTile(
                    icon: Icons.attach_money,
                    title: 'Salary',
                    amount: 1200.00,
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
        child: const Icon(Icons.person),
      ),
    );
  }
}

// Transaction Tile Widget
class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double amount;
  final Color color;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          amount > 0 ? '+\$${amount.toStringAsFixed(2)}' : '-\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: amount > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
