// services/user_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService {
  static const String baseUrl = 'http://localhost:3000/api/users';

  // Register a new user
  Future<void> addUser(String username, String email, String password, bool isActive) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
        'isActive': isActive,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user: ${response.reasonPhrase}');
    }
  }

  // Fetch users
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users: ${response.reasonPhrase}');
    }
  }

  // Login a user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }
}

// User model class
class User {
  final int id;
  final String username;
  final String email;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isActive: json['isActive'],
    );
  }
}
