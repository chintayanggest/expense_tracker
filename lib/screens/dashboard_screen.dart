// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';
import '../models/unified_models.dart';

import 'add_transaction_screen.dart';
import 'category_transactions_screen.dart';
import 'manage_accounts_screen.dart';
import 'manage_categories_screen.dart';
import 'transaction_detail_screen.dart';

import '../widgets/transaction_chart.dart';

enum FilterPeriod { daily, monthly, yearly }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FilterPeriod _selectedPeriod = FilterPeriod.daily;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        Provider.of<TransactionProvider>(context, listen: false)
            .fetchData(user.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // =========================
  // PERIOD NAVIGATION
  // =========================

  void _goToPreviousPeriod() {
    setState(() {
      if (_selectedPeriod == FilterPeriod.daily) {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      } else if (_selectedPeriod == FilterPeriod.monthly) {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month - 1);
      } else {
        _selectedDate = DateTime(_selectedDate.year - 1);
      }
    });
  }

  void _goToNextPeriod() {
    setState(() {
      final now = DateTime.now();

      if (_selectedPeriod == FilterPeriod.daily) {
        if (_selectedDate.year == now.year &&
            _selectedDate.month == now.month &&
            _selectedDate.day == now.day) return;

        _selectedDate = _selectedDate.add(const Duration(days: 1));
      } else if (_selectedPeriod == FilterPeriod.monthly) {
        if (_selectedDate.year == now.year &&
            _selectedDate.month >= now.month) return;

        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month + 1);
      } else {
        if (_selectedDate.year >= now.year) return;

        _selectedDate = DateTime(_selectedDate.year + 1);
      }
    });
  }

  // =========================
  // FILTER
  // =========================

  List<TransactionModel> _getFilteredTransactions(
      List<TransactionModel> allTransactions) {
    return allTransactions.where((tx) {
      if (_selectedPeriod == FilterPeriod.daily) {
        return tx.date.year == _selectedDate.year &&
            tx.date.month == _selectedDate.month &&
            tx.date.day == _selectedDate.day;
      } else if (_selectedPeriod == FilterPeriod.monthly) {
        return tx.date.year == _selectedDate.year &&
            tx.date.month == _selectedDate.month;
      } else {
        return tx.date.year == _selectedDate.year;
      }
    }).toList();
  }

  String _getFormattedDate() {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (_selectedPeriod == FilterPeriod.daily) {
      return '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
    } else if (_selectedPeriod == FilterPeriod.monthly) {
      return '${months[_selectedDate.month - 1]} ${_selectedDate.year}';
    } else {
      return '${_selectedDate.year}';
    }
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final allFilteredTransactions =
        _getFilteredTransactions(transactionProvider.transactions);

        final expenseTransactions = allFilteredTransactions
            .where((tx) => tx.type == TransactionType.expense)
            .toList();

        final incomeTransactions = allFilteredTransactions
            .where((tx) => tx.type == TransactionType.income)
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFF121212),

          // =========================
          // DRAWER
          // =========================

          drawer: Drawer(
            backgroundColor: const Color(0xFF121212),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFFC6FF00)),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.account_balance_wallet,
                      color: Colors.white),
                  title: const Text(
                    'Rekening (Accounts)',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ManageAccountsScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading:
                  const Icon(Icons.category, color: Colors.white),
                  title: const Text(
                    'Kategori (Categories)',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ManageCategoriesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // =========================
          // BODY
          // =========================

          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: const Color(0xFF121212),
                  pinned: true,
                  floating: true,
                  expandedHeight: 200,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: const Color(0xFF121212),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          const Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFC6FF00),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Rp${transactionProvider.totalBalance.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFFC6FF00),
                    labelColor: const Color(0xFFC6FF00),
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Expenses'),
                      Tab(text: 'Income'),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFF121212),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // =========================
                        // SEGMENTED BUTTON
                        // =========================

                        SegmentedButton<FilterPeriod>(
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                              if (states.contains(
                                  WidgetState.selected)) {
                                return const Color(0xFFC6FF00);
                              }
                              return const Color(0xFF1E1E1E);
                            }),
                            foregroundColor:
                            WidgetStateProperty.resolveWith((states) {
                              if (states.contains(
                                  WidgetState.selected)) {
                                return Colors.black;
                              }
                              return Colors.white;
                            }),
                          ),
                          segments: const [
                            ButtonSegment(
                                value: FilterPeriod.daily,
                                label: Text('Day')),
                            ButtonSegment(
                                value: FilterPeriod.monthly,
                                label: Text('Month')),
                            ButtonSegment(
                                value: FilterPeriod.yearly,
                                label: Text('Year')),
                          ],
                          selected: {_selectedPeriod},
                          onSelectionChanged: (newSel) {
                            setState(() {
                              _selectedPeriod = newSel.first;
                              _selectedDate = DateTime.now();
                            });
                          },
                        ),

                        const SizedBox(height: 8),

                        // =========================
                        // DATE NAVIGATION
                        // =========================

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              iconSize: 32,
                              onPressed: _goToPreviousPeriod,
                              style: ButtonStyle(
                                foregroundColor:
                                WidgetStateProperty.resolveWith(
                                        (states) {
                                      if (states.contains(
                                          WidgetState.pressed)) {
                                        return const Color(0xFFC6FF00);
                                      }
                                      return Colors.white;
                                    }),
                              ),
                            ),

                            Text(
                              _getFormattedDate(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC6FF00),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              iconSize: 32,
                              onPressed: _goToNextPeriod,
                              style: ButtonStyle(
                                foregroundColor:
                                WidgetStateProperty.resolveWith(
                                        (states) {
                                      if (states.contains(
                                          WidgetState.pressed)) {
                                        return const Color(0xFFC6FF00);
                                      }
                                      return Colors.white;
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },

            body: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(
                    expenseTransactions, TransactionType.expense),
                _buildTabContent(
                    incomeTransactions, TransactionType.income),
              ],
            ),
          ),

          // =========================
          // FAB
          // =========================

          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFC6FF00),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const AddTransactionScreen(),
                ),
              );
            },
            child: const Icon(Icons.add, color: Color(0xFF121212)),
          ),
        );
      },
    );
  }

  // =========================
  // TAB CONTENT
  // =========================

  Widget _buildTabContent(
      List<TransactionModel> transactions, TransactionType type) {
    return Column(
      children: [
        Container(
          height: 220,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: TransactionChart(
            transactions: transactions,
            type: type,
            backgroundColor: const Color(0xFF121212),
          ),
        ),

        const Divider(color: Colors.white24),

        Expanded(
          child: TransactionListView(transactions: transactions),
        ),
      ],
    );
  }
}

// =========================
// TRANSACTION LIST VIEW
// =========================

class TransactionListView extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionListView({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions in this period yet.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isExpense = tx.type == TransactionType.expense;

        return ListTile(
          tileColor: const Color(0xFF1E1E1E),

          leading: CircleAvatar(
            backgroundColor: tx.category.color.withOpacity(0.2),
            child: Icon(tx.category.icon, color: tx.category.color),
          ),

          title: Text(
            tx.category.name,
            style: const TextStyle(color: Colors.white),
          ),

          subtitle: Text(
            tx.notes ?? tx.account.name,
            style: const TextStyle(color: Colors.white70),
          ),

          trailing: Text(
            '${isExpense ? "-" : "+"}Rp${tx.amount.toStringAsFixed(0)}',
            style: TextStyle(
              color:
              isExpense ? Colors.redAccent : Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TransactionDetailScreen(transaction: tx),
              ),
            );
          },
        );
      },
    );
  }
}
