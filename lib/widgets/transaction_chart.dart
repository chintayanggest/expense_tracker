import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/transaction_category.dart';

class TransactionChart extends StatelessWidget {
  final List<Transaction> transactions;
  final TransactionType type;

  const TransactionChart({
    super.key,
    required this.transactions,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final totalValue = transactions.fold(0.0, (sum, item) => sum + item.amount);

    if (totalValue == 0) {
      return Center(
        child: Text(
          'No ${type.toString().split('.').last} data for this period.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final Map<TransactionCategory, double> categoryValues = {};
    for (var tx in transactions) {
      categoryValues.update(
        tx.category,
            (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    final List<PieChartSectionData> sections = categoryValues.entries.map((entry) {
      final category = entry.key;
      final totalAmount = entry.value;

      return PieChartSectionData(
        color: category.color,
        value: totalAmount,
        title: '${(totalAmount / totalValue * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 60,
            sectionsSpace: 2,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type == TransactionType.expense ? 'Expenses' : 'Income',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              'Rp${totalValue.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}