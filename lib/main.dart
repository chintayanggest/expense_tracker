import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/main_screen.dart';

void main() {
  // This line is good practice to ensure Flutter is ready.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We keep the provider at the top level.
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        // We use your friend's theme and settings.
        debugShowCheckedModeBanner: false,
        title: 'Eco Finance App', // Or your app's name
        theme: ThemeData(
          primarySwatch: Colors.teal, // Using the theme your friend added
        ),
        // And we set the home screen correctly, just once.
        home: const MainScreen(),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'screens/main_screen.dart';
// import 'screens/goals_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/transaction_provider.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainScreen(),
//       title: 'Eco Finance App',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//       ),
//       // 🏠 tetap dashboard utama
//       home: const MainScreen(),
//
//       // 🧭 tambahkan route agar bisa navigasi ke halaman goals
//       routes: {
//         '/goals': (context) => const GoalsPage(),
//       },
//     );
//   }
// }
