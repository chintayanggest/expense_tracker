import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';
import '../models/transaction_category.dart';
import '../models/transaction_type.dart';
import '../providers/transaction_provider.dart';
import 'dart:math';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController = TextEditingController();

  // State variables for the form
  TransactionType _selectedType = TransactionType.expense;
  IconData? _selectedIcon;
  Color _selectedColor = Colors.blue; // Default color

  // Function to show the icon picker
  // later

  // Function to show the color picker
  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() => _selectedColor = color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveCategory() {
    // Validation
    if (_nameController.text.isEmpty || _selectedIcon == null) {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name and select an icon.')),
      );
      return;
    }

    final newCategory = TransactionCategory(
      id: Random().nextDouble().toString(), // Simple unique ID
      name: _nameController.text,
      icon: _selectedIcon!,
      color: _selectedColor,
      type: _selectedType,
    );

    Provider.of<TransactionProvider>(context, listen: false).addCategory(newCategory);

    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Category'),
        actions: [
          // Add a save button to the app bar
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveCategory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Type Selector (Expense/Income)
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(value: TransactionType.expense, label: Text('Expense')),
                ButtonSegment(value: TransactionType.income, label: Text('Income')),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<TransactionType> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Icon and Color Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      // onTap: _pickIcon,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        child: _selectedIcon != null
                            ? Icon(_selectedIcon, size: 30, color: _selectedColor)
                            : const Icon(Icons.add, size: 30),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickColor,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: _selectedColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Save Button
            ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Category'),
            ),
          ],
        ),
      ),
    );
  }
}