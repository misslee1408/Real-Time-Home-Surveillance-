import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'ControlsOverlay.dart';

class RecordedPage extends StatefulWidget {
  @override
  _RecordedPageState createState() => _RecordedPageState();
}

class _RecordedPageState extends State<RecordedPage> {
  bool isRecording = false;

  Future<void> startRecording(String cameraUrl) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/recording/start-recording'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cameraUrl': cameraUrl,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Recording started: ${responseBody['filePath']}');
    } else {
      print('Failed to start recording');
    }
  }

  Future<void> stopRecording() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/recording/stop-recording'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Recording stopped: ${responseBody['filePath']}');
    } else {
      print('Failed to stop recording');
    }
  }

  void _toggleRecording(String cameraUrl) {
    setState(() {
      isRecording = !isRecording;
      if (isRecording) {
        startRecording(cameraUrl);
      } else {
        stopRecording();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/topback.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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
                  Container(
                    decoration: BoxDecoration(
                      color: _isLive ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 10),
                        SizedBox(width: 5),
                        Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 15,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  CameraFeedWidget(
                    title: 'camera 1',
                    videoUrl: 'http://10.176.26.108:8080/video',
                  ),
                  SizedBox(height: 10),
                  CameraFeedWidget(
                    title: 'camera 2',
                    videoUrl: 'http://10.176.26.108:8080/video',
                  ),
                  // Uncomment if you have another camera feed
                  // CameraFeedWidget(
                  //   title: 'Back Door',
                  //   videoUrl: 'http://41.70.47.48:8555/',
                  //   onPlay: _handleLive,
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 6,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  width: 400,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Record',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 100),
                      Switch(
                        value: isRecording,
                        onChanged: (value) {
                          _toggleRecording('http://10.176.26.108:8080/video');
                        },
                        activeColor: Colors.black,
                        activeTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

class CameraFeedWidget extends StatefulWidget {
  final String title;
  final String videoUrl;

  const CameraFeedWidget({
    Key? key,
    required this.title,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _CameraFeedWidgetState createState() => _CameraFeedWidgetState();
}

class _CameraFeedWidgetState extends State<CameraFeedWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _controller.play() : _controller.pause();
    });
  }

  void _rewindVideo() {
    // Implement rewind logic for the live video stream
    print('Rewinding live stream for ${widget.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white),
                onPressed: _rewindVideo,
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                onPressed: _togglePlayPause,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
