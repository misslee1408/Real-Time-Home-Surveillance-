import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/CameraControllerProvider.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'screens/NotificationsProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationsProvider(),
      child: MyApp(),
    ),
  );
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
      home: HomeScreen(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
    );
  }
}
