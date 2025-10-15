import 'package:flutter/material.dart';

class Account {
  final String id;
  final String name;
  final IconData icon; // To represent Wallet, Bank, etc.
  double balance; // The current balance of this account

  Account({
    required this.id,
    required this.name,
    required this.icon,
    this.balance = 0.0,
  });
}