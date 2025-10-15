import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/savings_goal_model.dart';
import 'package:intl/intl.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();


  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  // This function is the same as your friend's, it's perfect.
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- THIS FUNCTION IS NOW MUCH SIMPLER ---
  void _saveGoal() {
    // 1. Validate the form inputs
    if (!_formKey.currentState!.validate()) {
      return; // If not valid, do nothing.
    }

    // 2. Create the new SavingsGoal object from the form data
    final newGoal = SavingsGoal(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // A simple unique ID
      name: _nameController.text.trim(),
      targetAmount: double.parse(_targetAmountController.text),
      currentAmount: 0, // New goals always start at 0
      targetDate: _selectedDate,
    );

    // 3. Pop the screen and send the new goal object back to GoalsScreen
    Navigator.pop(context, newGoal);
  }

  @override
  Widget build(BuildContext context) {
    // The entire UI part is nearly identical, only the save button is simplified.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Goal'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Goal Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Goal Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Goal Name',
                  hintText: 'e.g., New MacBook',
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Target Amount Field
              TextFormField(
                controller: _targetAmountController,
                decoration: InputDecoration(
                  labelText: 'Target Amount',
                  hintText: '0',
                  prefixText: 'Rp ',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter target amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Target Date Field
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target Date (Optional)',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedDate == null ? Colors.grey : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => setState(() => _selectedDate = null),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- SIMPLIFIED SAVE BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveGoal, // Just calls our function directly
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Create Goal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}