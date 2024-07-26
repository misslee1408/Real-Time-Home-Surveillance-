
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StreamingPage extends StatefulWidget {
  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(
        'http://localhost:3000/api/streams/stream', // URL of the backend video stream
      );
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
        _controller.play();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Streaming'),
      ),
      body: Center(
        child: _error.isNotEmpty
            ? Text('Error: $_error')
            : _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
      ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}






// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class StreamingPage extends StatefulWidget {
//   @override
//   _StreamingPageState createState() => _StreamingPageState();
// }

// class _StreamingPageState extends State<StreamingPage> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   String _error = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//   }

//   Future<void> _initializeVideoPlayer() async {
//     try {
//       _controller = VideoPlayerController.network(
//         'http://username:password@41.70.47.48:8556/', // Ensure this URL points to a valid MP4 or WebM video
//       );
//       // _controller = VideoPlayerController.network('http://41.70.47.48:8556');
//       await _controller.initialize();
//       setState(() {
//         _isInitialized = true;
//         _controller.play();
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Streaming'),
//       ),
//       body: Center(
//         child: _error.isNotEmpty
//             ? Text('Error: $_error')
//             : _isInitialized
//                 ? AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   )
//                 : CircularProgressIndicator(),
//       ),
//       floatingActionButton: _isInitialized
//           ? FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   if (_controller.value.isPlaying) {
//                     _controller.pause();
//                   } else {
//                     _controller.play();
//                   }
//                 });
//               },
//               child: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             )
//           : null,
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
