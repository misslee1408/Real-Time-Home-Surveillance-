import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'footagesVideoPlayer.dart';

// Function to fetch the list of footages
Future<List<String>> fetchFootages() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/footages'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.cast<String>(); // Convert dynamic list to List<String>
  } else {
    throw Exception('Failed to load footages');
  }
}

// Page to display the list of videos
class FootagesPage extends StatefulWidget {
  @override
  _FootagesPageState createState() => _FootagesPageState();
}

class _FootagesPageState extends State<FootagesPage> {
  Future<List<String>>? footages;

  @override
  void initState() {
    super.initState();
    footages = fetchFootages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Footages')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpeg'), // Background image asset
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: footages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No footages found'));
            }

            final footageList = snapshot.data!;
            return ListView.separated(
              itemCount: footageList.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.6),
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final fileName = footageList[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tileColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Icon(Icons.video_collection, color: Colors.white),
                  title: Text(
                    fileName,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FootagePlayerPage(fileName: fileName),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
