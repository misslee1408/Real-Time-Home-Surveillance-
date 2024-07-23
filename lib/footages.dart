import 'package:flutter/material.dart';

class FootagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Back button with Footages title
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
                  Text(
                    'Footages',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // List of footages
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              bottom: 80,
              child: ListView(
                children: [
                  FootageItem(title: 'footage_9_1721029940084'),
                  SizedBox(height: 10),
                  FootageItem(title: 'footage_9_1721028078007'),
                  SizedBox(height: 10),
                  FootageItem(title: 'footage_9_1721028560041'),
                  SizedBox(height: 10),
                  FootageItem(title: 'footage_9_1721028784593'),
                ],
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
                      Navigator.pop(context);
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

class FootageItem extends StatelessWidget {
  final String title;

  FootageItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.image, color: Colors.black, size: 30),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}