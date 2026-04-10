import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Try to get IP from environment or use defaults
  // For Real Device testing, replace '10.0.2.2' with your Computer's Local IP (e.g., '192.168.1.5')
  final String baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:5000/api/auth' 
      : 'http://localhost:5000/api/auth';

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 5));
      
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await _saveUserData(data['user']);
      }
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Registration Error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // 1. Check for fallback credentials first to allow offline testing
    if (email == "test@gmail.com" && password == "password") {
       await _saveUserData({'name': 'Test User', 'email': email, 'id': '123'});
       return {'success': true, 'user': {'name': 'Test User'}, 'message': 'Logged in with Test Account'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await _saveUserData(data['user']);
      }
      return data;
    } on SocketException {
      return {
        'success': false, 
        'message': 'Server Unreachable. \n1. Is your backend running? \n2. If using a real device, use your PC IP instead of 10.0.2.2'
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', user['name'] ?? 'User');
    await prefs.setString('user_email', user['email'] ?? '');
    await prefs.setBool('is_logged_in', true);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? 'User';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
