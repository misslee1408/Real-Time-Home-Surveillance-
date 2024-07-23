import 'package:flutter/material.dart';
import 'api_service.dart'; // ApiService

class AddCameraScreen extends StatefulWidget {
  @override
  _AddCameraScreenState createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<AddCameraScreen> {
  final _cameraIdController = TextEditingController();
  final _cameraNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _urlController = TextEditingController();

  final ApiService _apiService = ApiService();

  void _addCamera() async {
    final name = _cameraNameController.text;
    final location = _locationController.text;
    final url = _urlController.text;

    try {
      await _apiService.addCamera(name, location, url);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera added successfully')));
      // Optionally, navigate to another screen or refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add camera')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'ADD CAMERA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(controller: _cameraIdController, hintText: 'Camera ID'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _cameraNameController, hintText: 'Camera name'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _locationController, hintText: 'Location'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _urlController, hintText: 'URL'),
                          SizedBox(height: 100),
                          ElevatedButton(
                            onPressed: _addCamera,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Add camera', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          // Handle person button press
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.white),
                        onPressed: () {
                          // Handle home button press
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          // Handle settings button press
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  CustomTextField({required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
