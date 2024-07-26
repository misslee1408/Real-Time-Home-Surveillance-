import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'backcamera.dart';
import 'live_stream_widget.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void _toggleTheme() {
    
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(), //HomeScreen(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

