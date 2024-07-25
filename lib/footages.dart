import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FootagesPage extends StatefulWidget {
  @override
  _FootagesPageState createState() => _FootagesPageState();
}

class _FootagesPageState extends State<FootagesPage> {
  List<String> footages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFootages();
  }

  Future<void> fetchFootages() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/footages'),
    );

    if (response.statusCode == 200) {
      setState(() {
        footages = List<String>.from(jsonDecode(response.body));
        isLoading = false;
      });
    } else {
      // Handle the error
      setState(() {
        isLoading = false;
      });
      print('Failed to load footages');
    }
  }

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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: footages.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            FootageItem(title: footages[index]),
                            SizedBox(height: 10),
                          ],
                        );
                      },
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
          Icon(Icons.video_library, color: Colors.black, size: 30),
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
