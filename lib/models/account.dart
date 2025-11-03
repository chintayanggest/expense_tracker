import 'package:flutter/material.dart';

class Account {
  final String id;
  String name;
  final IconData icon;
  double balance;

  Account({
    required this.id,
    required this.name,
    required this.icon,
    this.balance = 0.0,
  });
}