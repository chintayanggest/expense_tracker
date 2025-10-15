import 'package:flutter/material.dart';
import 'manage_accounts_screen.dart';
import 'manage_categories_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import 'add_transaction_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final expenseTransactions = transactionProvider.transactions.where((tx) => tx.type == TransactionType.expense).toList();
        final incomeTransactions = transactionProvider.transactions.where((tx) => tx.type == TransactionType.income).toList();
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text('Rekening(Accounts)'),
                  onTap:() {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder:(context) => const ManageAccountsScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Kategori(Categories)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageCategoriesScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: const Text('Dashboard'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [ Tab(text: 'Expenses'), Tab(text: 'Income'), ],
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Column(
                  children: [
                    const Text('Total Balance', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      'Rp${transactionProvider.totalBalance.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TransactionListView(transactions: expenseTransactions),
                    TransactionListView(transactions: incomeTransactions),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen()),); },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class TransactionListView extends StatelessWidget {
  final List<Transaction> transactions;
  const TransactionListView({super.key, required this.transactions});
  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) { return const Center( child: Text('No transactions in this category yet.'), ); }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: transaction.category.color.withOpacity(0.2),
            child: Icon(transaction.category.icon, color: transaction.category.color),
          ),
          title: Text(transaction.category.name),
          subtitle: Text(transaction.notes ?? ''),
          trailing: Text(
            '${transaction.type == TransactionType.expense ? '-' : '+'}Rp${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: transaction.type == TransactionType.expense ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}