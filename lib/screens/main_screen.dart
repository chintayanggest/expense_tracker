import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'recurring_screen.dart'; // ✅ Tambahkan import untuk recurring
import '../screens/goals_screen.dart';
import 'profile_screen.dart'; //

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;


  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    Placeholder(), // Goals
    RecurringScreen(), //
    Placeholder(), // Learn
    Placeholder(), // Profile

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const GoalsPage(),     // ⬅️ ganti Placeholder dengan GoalsPage
    const Placeholder(),   // Recurring screen (belum dibuat)
    const Placeholder(),   // Learn screen (belum dibuat)
    const Placeholder(),   // Profile screen (belum dibuat)

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(), // Halaman Dashboard
    Placeholder(),     // Goals (belum dibuat)
    Placeholder(),     // Recurring (belum dibuat)
    Placeholder(),     // Learn (belum dibuat)
    ProfileScreen(),   // Profile sudah dihubungkan


  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Recurring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.green,

        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,
      ),
    );
  }
}
