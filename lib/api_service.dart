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

<<<<<<< HEAD
  Future<List<dynamic>> getCameras() async {
    final response = await http.get(Uri.parse('$baseUrl/cameras'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cameras');
    }
  }
}
=======
  Future<List<Camera>> getCameras() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((camera) => Camera.fromJson(camera)).toList();
      } else {
        print('Failed to load cameras: ${response.body}');
        throw Exception('Failed to load cameras');
      }
    } catch (error) {
      print('Error fetching cameras: $error');
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
>>>>>>> 8c5199b4f3c61de37d55ba9ca6677433f78f7f3f
