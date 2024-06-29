import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/login.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<void> signIn(String username, String password) async {
    if (username == 'admin' && password == 'admin') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
    } else {
      throw Exception('Invalid username or password');
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}
