import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/unified_models.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';
import 'dart:io';
import 'fullscreen_image_viewer.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  void _deleteTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Do you want to permanently delete this transaction?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No', style: TextStyle(color: Colors.white70)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes', style: TextStyle(color: Color(0xFFC6FF00))),
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false)
                  .deleteTransaction(transaction.id);
              Navigator.of(context).popUntil((route) => route.isFirst);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted'),
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
        builder: (context) =>
            AddTransactionScreen(transactionToEdit: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        TransactionModel currentTransaction;
        try {
          currentTransaction = provider.transactions
              .firstWhere((t) => t.id == transaction.id);
        } catch (e) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(currentTransaction.date);

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            title: const Text(
              'Transaction Detail',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editTransaction(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => _deleteTransaction(context),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // =============================
                  // HEADER AMOUNT + CATEGORY
                  // =============================
                  Center(
                    child: Column(
                      children: [
                        Text(
                          currentTransaction.category.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp${currentTransaction.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: currentTransaction.type ==
                                TransactionType.expense
                                ? Colors.red
                                : const Color(0xFFC6FF00),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // =============================
                  // DETAILS
                  // =============================
                  _buildDetailRow(
                    'Account',
                    currentTransaction.account.name,
                    icon: currentTransaction.account.icon,
                  ),
                  const Divider(color: Colors.white24),

                  _buildDetailRow(
                    'Category',
                    currentTransaction.category.name,
                    icon: currentTransaction.category.icon,
                  ),
                  const Divider(color: Colors.white24),

                  _buildDetailRow(
                    'Date',
                    formattedDate,
                    icon: Icons.calendar_today,
                  ),
                  const Divider(color: Colors.white24),

                  _buildDetailRow(
                    'Notes',
                    (currentTransaction.notes != null &&
                        currentTransaction.notes!.isNotEmpty)
                        ? currentTransaction.notes!
                        : 'No notes provided',
                    icon: Icons.notes,
                  ),
                  const Divider(color: Colors.white24),

                  // =============================
                  // PHOTOS SECTION
                  // =============================
                  if (currentTransaction.imagePaths != null &&
                      currentTransaction.imagePaths!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Photos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: currentTransaction.imagePaths!.length,
                        itemBuilder: (context, index) {
                          final path = currentTransaction.imagePaths![index];
                          final tag = "image-$path-$index";

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FullscreenImageViewer(
                                          imagePath: path,
                                          heroTag: tag,
                                        ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: tag,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
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
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFC6FF00), size: 24),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    )),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
