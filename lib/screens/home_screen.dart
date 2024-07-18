import 'package:flutter/material.dart';
import 'package:real_time_home_surveillance_system/widgets/camera_control_widget.dart';
import 'package:real_time_home_surveillance_system/widgets/live_video_streaming_widget.dart';
import 'package:real_time_home_surveillance_system/widgets/motion_detection_widget.dart';
import 'package:real_time_home_surveillance_system/widgets/notification_widget.dart';
import 'package:real_time_home_surveillance_system/widgets/record_playback_widget.dart';
import 'package:real_time_home_surveillance_system/widgets/security_privacy_widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import ' LiveVideoStreamingWidget .dart';

import 'CameraControlWidget.dart';
import 'NotificationsWidget.dart';


class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomeScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Column(
      children: [
        LiveVideoStreamingWidget(),
        PrivacyAndSecuritySections(),
      ],
    ),
    NotificationsWidget(),
    Column(
      children: [
        CameraControlWidget(),
        PrivacyAndSecuritySections(),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveillance System'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.brightness_7 : Icons.brightness_2),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PrivacyAndSecuritySections extends StatelessWidget {
  void _showSetPasswordDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Enter Password'),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                if (passwordController.text == confirmPasswordController.text) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password set successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Security and Privacy'),
        ListTile(
          title: Text('Set Password'),
          trailing: Icon(Icons.lock),
          onTap: () => _showSetPasswordDialog(context),
        ),
        ListTile(
          title: Text('Privacy Settings'),
          trailing: Icon(Icons.privacy_tip),
          onTap: () {
            // Add privacy settings functionality
          },
        ),
      ],
    );
  }
}