import 'package:flutter/material.dart';
import '../models/user_model.dart'; // We are using the model we just created

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Let's create some temporary sample data for the user
  final User currentUser = User(
    id: '123',
    name: 'Nayla Syifa',
    email: 'nayla@example.com',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The blue bar at the top
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Section for user info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  // You can add a user image here later
                  backgroundImage: AssetImage('assets/images/profielpictes.jpg'),
                ),
                const SizedBox(height: 16),
                Text(
                  currentUser.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Menu options
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Action for editing profile later
              print('Edit Profile tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Action for settings later
              print('Settings tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Action for help later
              print('Help & Support tapped');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Action for logout later
              print('Logout tapped');
            },
          ),
        ],
      ),
    );
  }
}