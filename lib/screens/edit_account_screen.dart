// lib/screens/edit_account_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/unified_models.dart';
import '../providers/transaction_provider.dart';

class EditAccountScreen extends StatefulWidget {
  final Account account;

  const EditAccountScreen({super.key, required this.account});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    _balanceController = TextEditingController(
      text: widget.account.balance.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final newName = _nameController.text;
    final newBalance =
        double.tryParse(_balanceController.text) ?? widget.account.balance;

    if (newName.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Confirm Changes',
            style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to save these changes?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text('No', style: TextStyle(color: Colors.redAccent)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child:
            const Text('Yes', style: TextStyle(color: Colors.greenAccent)),
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false)
                  .updateAccount(
                id: widget.account.id,
                newName: newName,
                newBalance: newBalance,
              );
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _darkInput(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[850],
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // BACKGROUND HITAM 🔥
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Edit ${widget.account.name}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInput('Account Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _balanceController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: _darkInput('Current Balance'),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // CANCEL BUTTON
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),

                // SAVE BUTTON
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
