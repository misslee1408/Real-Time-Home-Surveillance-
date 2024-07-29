import 'package:flutter/material.dart';
import 'package:surveillance_system/api_service.dart';
import 'SettingsPage.dart';
import 'CameraControlWidget.dart';
import 'RecordedPages.dart';
import 'ProfilePage.dart';
import 'footages_list.dart';
import 'record.dart';
import 'live_stream_screen.dart';


class HomePage extends StatefulWidget {
  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Set default selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 1:
      // Handle home button
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text(
                      'WELCOME!', // to be made dynamic
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuButton(
                          icon: Icons.videocam,
                          text: 'Live Stream',
                          onPressed: () {
                            // Create a Camera object
                            final camera = Camera(
                              id: 1, // Provide the id
                              name: 'Camera 1',
                              streamurl: 'http://localhost:3000/api/streams/stream', location: '', isActive: true,
                            );

                            // Navigate to the LiveStreamScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveStreamScreen(camera: camera),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        MenuButton(
                          icon: Icons.emergency_recording,
                          text: 'Record stream',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecordedPage()),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        MenuButton(
                          icon: Icons.camera_alt_outlined,
                          text: 'Cameras',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>CameraPage()),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        MenuButton(
                          icon: Icons.photo,
                          text: 'Footages',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FootagesPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 90,
              right: 30,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCameraScreen()),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: _selectedIndex == 0 ? Colors.red : Colors.white,
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: _selectedIndex == 1 ? Colors.red : Colors.white,
                    ),
                    onPressed: () => _onItemTapped(1),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: _selectedIndex == 2 ? Colors.red : Colors.white,
                    ),
                    onPressed: () => _onItemTapped(2),
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

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  MenuButton({required this.icon, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        minimumSize: Size(300, 60), // Set a fixed size for the buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}