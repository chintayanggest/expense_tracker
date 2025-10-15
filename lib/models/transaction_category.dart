import 'package:flutter/material.dart';
import 'transaction_type.dart';

class TransactionCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}