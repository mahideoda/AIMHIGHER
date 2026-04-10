import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // Standard splash duration
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    // Check mounted again after async gap to satisfy lint and ensure stability
    if (!mounted) return;

    if (isLoggedIn) {
      // Use named route for cleaner navigation and to prevent black screens
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/splash_bg.jpg",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1A237E)),
          ),
          Container(color: Colors.black.withAlpha(120)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rocket_launch, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "ΛIMHIGHER",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                Text(
                  "REACH NEW HEIGHTS",
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 12,
                    letterSpacing: 4,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
