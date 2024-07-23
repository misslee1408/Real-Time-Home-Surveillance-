import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/cameras/';

  Future<void> addCamera(String name, String location, String streamurl, bool isActive) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'location': location,
        'streamurl': streamurl,
        'isActive': isActive,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add camera');
    }
  }

  Future<List<Camera>> getCameras() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((camera) => Camera.fromJson(camera)).toList();
    } else {
      throw Exception('Failed to load cameras');
    }
  }
}

class Camera {
  final int id;
  final String name;
  final String location;
  final String streamurl;
  final bool isActive;

  Camera({
    required this.id,
    required this.name,
    required this.location,
    required this.streamurl,
    required this.isActive,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      streamurl: json['streamurl'],
      isActive: json['isActive'],
    );
  }
}
