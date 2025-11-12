import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';
import 'dart:io';
import 'fullscreen_image_viewer.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  void _deleteTransaction(BuildContext context) {
    // confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Do you want to permanently delete this transaction?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false)
                  .deleteTransaction(transaction.id);
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted successfully!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _editTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(
          transactionToEdit: transaction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
        actions: [
          // Edit Button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTransaction(context),
          ),
          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTransaction(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount:', 'Rp${transaction.amount.toStringAsFixed(0)}'),
            const Divider(),
            _buildDetailRow('Account:', transaction.account.name, icon: transaction.account.icon),
            const Divider(),
            _buildDetailRow('Category:', transaction.category.name, icon: transaction.category.icon),
            const Divider(),
            _buildDetailRow('Date:', '${transaction.date.toLocal()}'.split(' ')[0]),
            const Divider(),
            _buildDetailRow('Notes:', transaction.notes ?? 'No notes provided'),
            const Divider(),

            if (transaction.imagePaths != null && transaction.imagePaths!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Photos', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: transaction.imagePaths!.length,
                  itemBuilder: (context, index) {
                    final path = transaction.imagePaths![index];
                    // Create a unique tag for the Hero animation
                    final heroTag = 'image-$path-$index';

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      // Make the image tappable
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenImageViewer(
                                imagePath: path,
                                heroTag: heroTag,
                              ),
                            ),
                          );
                        },
                        // The Hero widget enables the smooth animation
                        child: Hero(
                          tag: heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(path),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget to avoid code repetition
  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.grey[700]),
                const SizedBox(width: 8),
              ],
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}