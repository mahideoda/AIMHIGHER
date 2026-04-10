import 'package:flutter/material.dart';
import 'package:aimhigher_app/services/auth_service.dart';
import 'package:aimhigher_app/screens/register_screen.dart';
import 'package:aimhigher_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    final result = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );
    
    if (mounted) setState(() => _isLoading = false);

    if (result['success'] == true) {
      if (mounted) {
        // Clear stack and go home
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Image.asset(
                  'assets/images/signin.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.login, size: 80, color: Color(0xFF6C63FF)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const Text(
              'Login to your account',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(25),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    // Go to register page
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
