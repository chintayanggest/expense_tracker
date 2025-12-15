import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dashboard_screen.dart';
import 'goals_screen.dart';
import 'recurring_screen.dart';
import 'learn_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const GoalsScreen(),
    const RecurringScreen(),
    const LearnScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          color: Color(0xFFC6FF00), // background lime
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(0, Icons.dashboard_outlined, "Home",
                selectedIcon: Icons.dashboard),
            _buildItem(1, FontAwesomeIcons.bullseye, "Goals"),
            _buildItem(2, Icons.repeat, "Recurring"),
            _buildItem(3, Icons.menu_book, "Learn"),
            _buildItem(4, Icons.person_outline, "Profile",
                selectedIcon: Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, IconData icon, String label,
      {IconData? selectedIcon}) {
    final bool selected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: selected ? 58 : 44,   // besarin
            height: selected ? 58 : 44,  // biar bulat, bukan oval
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF121212) : Colors.transparent,
              shape: BoxShape.circle, // biar TIDAK LONJONG lagi
            ),
            child: Icon(
              selected ? (selectedIcon ?? icon) : icon,
              color:
              selected ? const Color(0xFFC6FF00) : const Color(0xFF121212),
              size: selected ? 28 : 25, // icon besar saat aktif
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: TextStyle(
              color:
              selected ? const Color(0xFF121212) : const Color(0xFF121212),
              fontSize: selected ? 13 : 12,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
