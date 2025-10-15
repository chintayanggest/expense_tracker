import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // FOTO PROFIL
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
            ),
            const SizedBox(height: 16),

            // NAMA DAN EMAIL
            const Text(
              'Nayla Syifa',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'nayla@example.com',
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            // CARD MENU
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blueAccent),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.blueAccent),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: Colors.blueAccent),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
