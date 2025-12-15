// FULL PROFILE SCREEN (RE-DESIGNED) — LIME HEADER + BLACK CURVED BACKGROUND
// TANPA MENGUBAH ISI / FITUR, HANYA DESAIN SESUAI PERMINTAAN

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';

// ============================================================================
// 1. EDIT PROFILE SCREEN
// ============================================================================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _imagePath = user.profilePath;
    }
  }

  Future<void> _pickImage() async {
    if (Platform.isAndroid) {
      await Permission.photos.request();
      await Permission.storage.request();
    }

    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    } catch (_) {}
  }

  void _save() {
    if (_nameController.text.isEmpty) return;
    Provider.of<AuthProvider>(context, listen: false)
        .updateProfile(_nameController.text, _imagePath);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated!"),
        backgroundColor: Color(0xFFC6FF00),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                  _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? const Icon(Icons.camera_alt,
                      size: 40, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              const Text("Tap to change photo",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 32),

              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC6FF00), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6FF00),
                    foregroundColor: const Color(0xFF121212),
                  ),
                  child:
                  const Text("Save Changes", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 2. HELP SUPPORT SCREEN
// ============================================================================
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpTile(
            title: "How do I add a transaction?",
            text:
            "Go to the Dashboard and click the '+' button at the bottom right corner.",
          ),
          _HelpTile(
            title: "Can I edit my budget goals?",
            text:
            "Yes, go to the Goals tab, click on a goal, and select edit.",
          ),
          _HelpTile(
            title: "Is my data safe?",
            text: "Yes, all data is stored locally on your device.",
          ),
          _HelpTile(
            title: "How do I contact support?",
            text: "Email us at support@fintrack.com",
          ),
        ],
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final String title;
  final String text;
  const _HelpTile({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedIconColor: Colors.white,
      iconColor: const Color(0xFFC6FF00),
      title: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(text,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        )
      ],
    );
  }
}

// ============================================================================
// 3. SETTINGS SCREEN
// ============================================================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _settingsTile(Icons.language, "Language", "English"),
          const Divider(color: Colors.white24),
          _settingsTile(Icons.notifications, "Notifications", "On"),
          const Divider(color: Colors.white24),
          _settingsTile(Icons.currency_exchange, "Currency", "IDR (Rp)"),
          const Divider(color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Delete Account",
                style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  title: const Text("Delete Account?",
                      style: TextStyle(color: Colors.white)),
                  content: const Text(
                    "This will permanently erase all your data.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.white70))),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Provider.of<AuthProvider>(context, listen: false)
                            .deleteAccount();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                              (route) => false,
                        );
                      },
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFC6FF00)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Text(value, style: const TextStyle(color: Colors.white70)),
    );
  }
}

// ============================================================================
// 4. MAIN PROFILE SCREEN — RE-DESIGNED (LIME HEADER + BLACK CURVE + CENTERED AVATAR)
// ============================================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final name = user?.name ?? "User";
    final email = user?.email ?? "";
    final profilePath = user?.profilePath;

    // --- PENGATURAN UKURAN ---
    const double headerHeight = 200.0; // Tinggi area hijau
    const double cardTopMargin = 160.0; // Jarak kartu hitam dari atas (supaya numpuk)
    const double profileRadius = 50.0; // Ukuran foto profil

    return Scaffold(
      backgroundColor: const Color(0xFFC6FF00), // Background dasar (Hijau Lime)
      extendBodyBehindAppBar: true, // Agar header hijau mentok ke atas status bar
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparan agar warna background terlihat
        elevation: 0,
        foregroundColor: const Color(0xFF121212), // Icon/Text warna hitam agar kontras
        automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          /// ==== LAYER 1: HEADER BACKGROUND (HIJAU) ====
          Container(
            height: headerHeight,
            width: double.infinity,
            color: const Color(0xFFC6FF00),
          ),

          /// ==== LAYER 2: BODY CARD (HITAM) ====
          Container(
            margin: const EdgeInsets.only(top: cardTopMargin),
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                // Spacer kosong agar teks Nama tidak tertutup Avatar
                const SizedBox(height: profileRadius + 10),

                // Nama & Email (Sekarang ada di dalam area hitam)
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                // Menu List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _menuItem(
                        context,
                        icon: Icons.edit,
                        title: "Edit Profile",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _menuItem(
                        context,
                        icon: Icons.currency_exchange,
                        title: "Currency: IDR",
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _menuItem(
                        context,
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _menuItem(
                        context,
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _menuItem(
                        context,
                        icon: Icons.logout,
                        title: "Logout",
                        color: Colors.redAccent,
                        onTap: () => _showLogoutDialog(context),
                      ),
                      // Tambahan padding bawah agar scroll enak
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ==== LAYER 3: FLOATING AVATAR ====
          Positioned(
            // Rumus posisi: (Margin Top Card) dikurangi (Radius Avatar)
            // 160 - 50 = 110. Ini membuat avatar tepat di tengah garis.
            top: cardTopMargin - profileRadius,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                // Container pembungkus untuk membuat efek 'Border' tebal
                // Warnanya disamakan dengan warna kartu (Hitam 0xFF121212)
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF121212),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: profileRadius,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                  profilePath != null ? FileImage(File(profilePath)) : null,
                  child: profilePath == null
                      ? const Icon(Icons.person, size: 50, color: Color(0xFFC6FF00))
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===== LOGOUT DIALOG =====
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to log out?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              // Pastikan logic logout sesuai provider kamu
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// ===== MENU ITEM WIDGET =====
  Widget _menuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color color = Colors.white,
      }) {
    return Material(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFC6FF00)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}