import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7), // Adding a dark overlay for better readability
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSettingsOption(
                            context,
                            icon: Icons.lock,
                            text: 'Change Password',
                            onTap: () {
                              // Change password logic
                            },
                          ),
                          SizedBox(height: 20),
                          _buildSettingsOption(
                            context,
                            icon: Icons.notifications,
                            text: 'Notifications',
                            onTap: () {
                              // Notifications settings logic
                            },
                          ),
                          SizedBox(height: 20),
                          _buildSettingsOption(
                            context,
                            icon: Icons.privacy_tip,
                            text: 'Privacy',
                            onTap: () {
                              // Privacy settings logic
                            },
                          ),
                          SizedBox(height: 20),
                          _buildSettingsOption(
                            context,
                            icon: Icons.logout,
                            text: 'Logout',
                            onTap: () {
                              // Logout logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
