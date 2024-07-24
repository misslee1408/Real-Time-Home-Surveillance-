import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ControlsOverlay.dart';


class RecordedPage extends StatefulWidget {
  @override
  _RecordedPageState createState() => _RecordedPageState();
}

class _RecordedPageState extends State<RecordedPage> {
  bool isRecording = false;

  Future<void> startRecording(String cameraUrl) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/recording/start-recording'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cameraUrl': cameraUrl,
      }),
    );

    if (response.statusCode == 200) {
      // Recording started successfully
      final responseBody = jsonDecode(response.body);
      print('Recording started: ${responseBody['filePath']}');
    } else {
      // Failed to start recording
      print('Failed to start recording');
    }
  }

  Future<void> stopRecording() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/recording/stop-recording'),
    );

    if (response.statusCode == 200) {
      // Recording stopped successfully
      final responseBody = jsonDecode(response.body);
      print('Recording stopped: ${responseBody['filePath']}');
    } else {
      // Failed to stop recording
      print('Failed to stop recording');
    }
  }

  void _toggleRecording(String cameraUrl) {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        startRecording(cameraUrl);
      } else {
        stopRecording();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Top background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/topback.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Bottom background image
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Back button with Live icon
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 10),
                        SizedBox(width: 5),
                        Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Camera feeds section
            Positioned(
              top: MediaQuery.of(context).size.height / 15,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  CameraFeedWidget(
                    title: 'Front Door',
                    videoUrl: 'https://10.139.133.72:8080/video',
                  ),
                  SizedBox(height: 10),
                  CameraFeedWidget(
                    title: 'Back Door',
                    videoUrl: 'https://10.139.133.72:8080/video',
                  ),
                ],
              ),
            ),
            // Record button section
            Positioned(
              bottom: MediaQuery.of(context).size.height / 6,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  width: 400,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Record',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 100),
                      Switch(
                        value: isRecording,
                        onChanged: (value) {
                          _toggleRecording('http://your-camera-url');
                        },
                        activeColor: Colors.black,
                        activeTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom navigation buttons
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
