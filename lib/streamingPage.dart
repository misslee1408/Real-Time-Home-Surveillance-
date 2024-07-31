import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';


class StreamingPage extends StatefulWidget {
  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  String _error = '';
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(
        'http://localhost:3000/api/streams/stream', // URL of the backend video stream
      )
        ..addListener(() {
          if (_controller.value.hasError) {
            setState(() {
              _error = _controller.value.errorDescription ?? 'Unknown error';
            });
          }

          // Update buffering state
          setState(() {
            _isBuffering = _controller.value.isBuffering;
          });
        });
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
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      if (_isBuffering) ...[
                        Container(
                          color: Colors.black45,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ],
                      _buildControlsOverlay(),
                    ],
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

  Widget _buildControlsOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: VideoProgressIndicator(
        _controller,
        allowScrubbing: true,
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
