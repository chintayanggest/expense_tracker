import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/savings_goal_model.dart';
import 'add_goal_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  // --- The list now starts empty! ---
  final List<SavingsGoal> _goals = [];

  // This function will handle the navigation to the "Add Goal" screen
  void _navigateAndAddGoal(BuildContext context) async {
    // We 'await' for the AddGoalScreen to pop and maybe return a new goal
    final newGoal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGoalScreen()),
    );

    // If the user saved a new goal, it will not be null
    if (newGoal != null && newGoal is SavingsGoal) {
      setState(() {
        _goals.add(newGoal); // Add the new goal to our list and rebuild the UI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      // --- The body now handles the empty case ---
      body: _goals.isEmpty
          ? const Center(
        child: Text(
          'No savings goals yet.\nTap the + button to add one!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _goals.length,
        itemBuilder: (context, index) {
          return _GoalCard(goal: _goals[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- The button now calls our navigation function ---
          _navigateAndAddGoal(context);
        },
        backgroundColor: const Color(0xFF00A86B),
        child: const Icon(Icons.add),
      ),
    );
  }
}


// This private helper widget is the same as before. No changes needed here.
class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('d MMM yyyy');
    final double progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final bool isCompleted = progress >= 1.0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(goal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('COMPLETED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(formatCurrency.format(goal.targetAmount), style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% achieved',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                if (goal.targetDate != null)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        formatDate.format(goal.targetDate!),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}