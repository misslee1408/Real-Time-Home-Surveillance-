import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveVideoStreamingWidget extends StatefulWidget {
  @override
  _LiveVideoStreamingWidgetState createState() => _LiveVideoStreamingWidgetState();
}

class _LiveVideoStreamingWidgetState extends State<LiveVideoStreamingWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('http://<raspberry-pi-ip>:<port>/video_feed')
      ..initialize().then((_) {
        setState(() {
          _isPlaying = false;
        });
      }).catchError((error) {
        print("Error initializing video player: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isInitialized) {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        _isPlaying = _controller.value.isPlaying;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5, // Increased height
          color: Colors.black,
          child: Center(
            child: _controller.value.isInitialized
                ? Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
            )
                : CircularProgressIndicator(),
          ),
        ),
        if (_controller.value.isInitialized)
          VideoProgressIndicator(_controller, allowScrubbing: true),
      ],
    );
  }
}
