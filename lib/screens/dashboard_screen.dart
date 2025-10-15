import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar is the top bar of the screen
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Implement sorting/filtering logic
            },
          ),
        ],
      ),

      // The body of the screen
      body: Column(
        children: [
          // 1. SUMMARY SECTION (Placeholder)
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            width: double.infinity,
            child: const Center(
              child: Text(
                'Summary & Chart will go here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // A title for the list
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // 2. TRANSACTION LIST (Placeholder)
          // The Expanded widget makes the list take up all remaining space
          Expanded(
            child: Center(
              child: Text(
                'A list of transactions will go here.',
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to the Add Transaction Screen
          if (kDebugMode) {
            print('FAB Tapped!');
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}