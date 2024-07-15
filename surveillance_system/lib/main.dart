import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/CameraControllerProvider.dart';
import 'screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraControllerProvider(),
      child: MaterialApp(
        title: 'Surveillance System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}













