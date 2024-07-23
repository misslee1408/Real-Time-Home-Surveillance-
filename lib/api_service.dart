import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000/api/cameras'; // Replace with your backend URL

  Future<void> addCamera(String name, String location, String url) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cameras'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'location': location,
        'streamurl': url,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add camera');
    }
  }

  Future<List<dynamic>> getCameras() async {
    final response = await http.get(Uri.parse('$baseUrl/cameras'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cameras');
    }
  }
}