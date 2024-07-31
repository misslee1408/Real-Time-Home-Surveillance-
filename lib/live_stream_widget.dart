import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStreamWidget extends StatefulWidget {
  final String streamUrl;

  LiveStreamWidget({required this.streamUrl});

  @override
  _LiveStreamWidgetState createState() => _LiveStreamWidgetState();
}

class _LiveStreamWidgetState extends State<LiveStreamWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isRecording = false;
  bool _isMuted = false;

  final String username = 'admin';
  final String password = 'password';
  final String backendUrl = 'http://localhost:3000/api/recording'; // Replace with your backend IP address

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl)
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
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _rewind() {
    final position = _controller.value.position;
    final rewindPosition = position - Duration(seconds: 10);
    _controller.seekTo(rewindPosition);
  }

  void _forward() {
    final position = _controller.value.position;
    final forwardPosition = position + Duration(seconds: 10);
    _controller.seekTo(forwardPosition);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleRecording() async {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  Future<void> _startRecording() async {
    final url = '$backendUrl/start-recording';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cameraUrl': widget.streamUrl,
        }),
      );

      if (response.statusCode == 200) {
        print('Recording started successfully.');
      } else {
        print('Failed to start recording: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    final url = '$backendUrl/stop-recording';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Recording stopped successfully.');
      } else {
        print('Failed to stop recording: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          if (_controller.value.isInitialized)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: _toggleMute,
                  ),
                ],
              ),
            ),
          if (_controller.value.isInitialized)
            Positioned(
              bottom: 20.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.white54,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10, size: 30.0, color: Colors.white),
                          onPressed: _rewind,
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: Icon(Icons.forward_10, size: 30.0, color: Colors.white),
                          onPressed: _forward,
                        ),
                        IconButton(
                          icon: Icon(
                            _isRecording ? Icons.circle : Icons.circle_outlined,
                            size: 30.0,
                            color: _isRecording ? Colors.red : Colors.white,
                          ),
                          onPressed: _toggleRecording,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
