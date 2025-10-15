import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/goals_screen.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      title: 'Eco Finance App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // 🏠 tetap dashboard utama
      home: const MainScreen(),

      // 🧭 tambahkan route agar bisa navigasi ke halaman goals
      routes: {
        '/goals': (context) => const GoalsPage(),
      },
    );
  }
}
