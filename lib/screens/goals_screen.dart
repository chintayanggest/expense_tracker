// lib/pages/goals_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/savings_goal_model.dart';
import 'add_goal_screen.dart';
import 'goal_detail_screen.dart';
import 'dart:io';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  // final GoalsDatabaseService _dbService = GoalsDatabaseService.instance;
  List<SavingsGoal> _goals = [];
  bool _isLoading = true;
  double _totalSavings = 0.0;
  double _totalTarget = 0.0;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() => _isLoading = true);
    // final goals = await _dbService.getAllGoals();

    double totalSaved = 0.0;
    double totalTarget = 0.0;
    for (var goal in _goals) {
      totalSaved += goal.currentAmount;
      totalTarget += goal.targetAmount;
    }

    setState(() {
      _goals = _goals;
      _totalSavings = totalSaved;
      _totalTarget = totalTarget;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC6FF00),
            strokeWidth: 3,
          ),
        )
            : _goals.isEmpty
            ? _buildEmptyState()
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildMainCard(),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your Goals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildGoalsList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoalPage()),
          );
          if (result == true) _loadGoals();
        },
        backgroundColor: const Color(0xFFC6FF00),
        elevation: 8,
        child: const Icon(Icons.add, size: 28, color: Color(0xFF121212)),
      ),
    );
  }

  Widget _buildMainCard() {
    final overallProgress = _totalTarget > 0 ? _totalSavings / _totalTarget : 0.0;
    final progressPercentage = (overallProgress * 100).clamp(0, 100).toInt();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFC6FF00),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC6FF00).withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Savings Goals',
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flag, color: Color(0xFFC6FF00), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${_goals.length}',
                      style: const TextStyle(
                        color: Color(0xFFC6FF00),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Donut Chart
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: overallProgress,
                  strokeWidth: 35,
                  backgroundColor: const Color(0xFF121212).withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF121212),
                  ),
                ),
              ),
              Text(
                '$progressPercentage%',
                style: const TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Savings Info
          Column(
            children: [
              Text(
                'RP ${NumberFormat('#,###', 'id_ID').format(_totalSavings.toInt())}',
                style: const TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your savings',
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.savings_outlined,
              size: 80,
              color: Color(0xFFC6FF00),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Goals Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start saving for your dreams!',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddGoalPage()),
              );
              if (result == true) _loadGoals();
            },
            icon: const Icon(Icons.add, color: Color(0xFF121212)),
            label: const Text(
              'Create Your First Goal',
              style: TextStyle(color: Color(0xFF121212)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC6FF00),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _goals.map((goal) => _buildGoalCard(goal)).toList(),
      ),
    );
  }

  Widget _buildGoalCard(SavingsGoal goal) {
    final progressPercentage = (goal.progress * 100).clamp(0, 100).toInt();

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailPage(goal: goal),
          ),
        );
        if (result == true) _loadGoals();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFC6FF00),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC6FF00).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (goal.imagePath != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.file(
                  File(goal.imagePath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Color(0xFFC6FF00),
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.savings,
                    size: 80,
                    color: Color(0xFFC6FF00),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          goal.name,
                          style: const TextStyle(
                            color: Color(0xFF121212),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$progressPercentage%',
                          style: const TextStyle(
                            color: Color(0xFFC6FF00),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(goal.currentAmount)}',
                        style: const TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(goal.targetAmount)}',
                        style: TextStyle(
                          color: const Color(0xFF121212).withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      backgroundColor: const Color(0xFF121212).withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF121212),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  if (goal.targetDate != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: const Color(0xFF121212).withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Target: ${DateFormat('dd MMM yyyy').format(goal.targetDate!)}',
                          style: TextStyle(
                            color: const Color(0xFF121212).withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}