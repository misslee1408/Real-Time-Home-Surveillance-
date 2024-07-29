// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:video_player/video_player.dart';

// class FootagesPage extends StatefulWidget {
//   @override
//   _FootagesPageState createState() => _FootagesPageState();
// }

// class _FootagesPageState extends State<FootagesPage> {
//   List<Map<String, String>> footages = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchFootages();
//   }

//   Future<void> fetchFootages() async {
//   final response = await http.get(
//     Uri.parse('http://localhost:3000/api/footages/'),
//   );

//   if (response.statusCode == 200) {
//     setState(() {
//       footages = List<Map<String, String>>.from(
//         jsonDecode(response.body).map((item) => {
//           'name': item['name'],
//           'url': item['url']
//         }),
//       );
//       isLoading = false;
//     });
//   } else {
//     // Handle the error
//     setState(() {
//       isLoading = false;
//     });
//     print('Failed to load footages');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Background image
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/background.jpeg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             // Back button with Footages title
//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     'Footages',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // List of footages
//             Positioned(
//               top: 60,
//               left: 20,
//               right: 20,
//               bottom: 80,
//               child: isLoading
//                   ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : ListView.builder(
//                       itemCount: footages.length,
//                       itemBuilder: (context, index) {
//                         final footage = footages[index];
//                         return Column(
//                           children: [
//                             FootageItem(
//                               title: footage['name']!,
//                               url: footage['url']!,
//                             ),
//                             SizedBox(height: 10),
//                           ],
//                         );
//                       },
//                     ),
//             ),
//             // Bottom navigation buttons
//             Positioned(
//               bottom: 20,
//               left: 20,
//               right: 20,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.person, color: Colors.white),
//                     onPressed: () {
//                       // Handle button press
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.home, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.settings, color: Colors.white),
//                     onPressed: () {
//                       // Handle button press
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FootageItem extends StatelessWidget {
//   final String title;
//   final String url;

//   FootageItem({required this.title, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.video_library, color: Colors.black, size: 30),
//           SizedBox(width: 20),
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => VideoPlayerScreen(url: url),
//                   ),
//                 );
//               },
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayerScreen extends StatefulWidget {
//   final String url;

//   VideoPlayerScreen({required this.url});

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Player')),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               _controller.play();
//             }
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
