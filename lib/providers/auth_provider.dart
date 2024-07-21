  // lib/providers/auth_provider.dart handling the authentication details # flonicah
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token; // Change to nullable type
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> register(String username, String password, String email) async {
    final url = 'http://localhost:3000/api/users'; // Update to your registration endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password, 'email': email}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      _token = data['token']; // Assuming the response contains a token
      notifyListeners();
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> login(String username, String password) async {
    final url = 'http://localhost:3000/api/users/login'; // Update to your login endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token']; // Assuming the response contains a token
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  void logout() {
    _token = null; // Now _token is nullable
    notifyListeners();
  }
}
