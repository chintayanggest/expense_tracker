import 'package:flutter/material.dart';

class ManageAccountsScreen extends StatelessWidget {
  const ManageAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Accounts')),
      body: const Center(
        child: Text('Account management UI will be built here.'),
      ),
    );
  }
}