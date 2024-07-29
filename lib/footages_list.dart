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
      body: FutureBuilder<List<String>>(
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
          return ListView.builder(
            itemCount: footageList.length,
            itemBuilder: (context, index) {
              final fileName = footageList[index];
              return ListTile(
                title: Text(fileName),
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
    );
  }
}
