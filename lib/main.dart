import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart'; // Ensure this path is correct

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
      // home: HomePage(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'LoginScreen.dart';
// import 'HomeScreen.dart'; // Ensure this path is correct
// import 'live_stream_widget.dart'; // Ensure this path is correct

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool isDarkMode = false;

//   void _toggleTheme() {
//     setState(() {
//       isDarkMode = !isDarkMode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // Remove the debug banner
//       theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: HomePage(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final Function toggleTheme;
//   final bool isDarkMode;

//   HomePage({required this.toggleTheme, required this.isDarkMode});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
//             onPressed: () {
//               toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => LiveStreamWidget(
//                   streamUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
//                 ),
//               ),
//             );
//           },
//           child: Text('Start Live Stream'),
//         ),
//       ),
//     );
//   }
// }
