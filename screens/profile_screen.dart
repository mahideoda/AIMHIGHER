import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aimhigher_app/services/auth_service.dart';
import 'package:aimhigher_app/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Loading...';
  String _email = 'Loading...';
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? 'User';
      _email = prefs.getString('user_email') ?? 'No email';
    });
  }

  void _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AimHigherApp.of(context);
    final isDark = appState.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _handleLogout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFF1A237E),
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 5)],
                      ),
                      child: const Icon(Icons.camera_alt, color: Color(0xFF1A237E), size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(_name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(_email, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 40),
            
            _buildSectionHeader('General'),
            _buildOption(
              icon: Icons.person_outline,
              title: 'Edit Profile Information',
              onTap: () async {
                final result = await Navigator.pushNamed(context, '/edit_profile');
                if (result == true) _loadUserData();
              },
            ),
            _buildOption(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: isDark ? 'Dark Theme Enabled' : 'Light Theme Enabled',
              trailing: Switch(
                value: isDark,
                onChanged: (value) => appState.toggleTheme(value),
                activeColor: const Color(0xFF1A237E),
              ),
            ),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Career Progress'),
            _buildOption(
              icon: Icons.history,
              title: 'Assessment History',
              onTap: () {},
            ),
            _buildOption(
              icon: Icons.bookmark_border,
              title: 'Saved Roadmaps',
              onTap: () {},
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Support'),
            _buildOption(
              icon: Icons.help_outline,
              title: 'Help & Feedback',
              onTap: () {},
            ),
            _buildOption(
              icon: Icons.info_outline,
              title: 'About AimHigher',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(20)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF1A237E).withAlpha(15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF1A237E), size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
    );
  }
}
