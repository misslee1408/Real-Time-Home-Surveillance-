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

  void _seekToRelativePosition(Offset position, BuildContext context) {
    if (_controller.value.isInitialized) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final double dx = position.dx / box.size.width;
      final Duration newPosition = _controller.value.duration * dx;
      _controller.seekTo(newPosition);
    }
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
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colors.black,
          child: Center(
            child: _controller.value.isInitialized
                ? GestureDetector(
              onTap: _togglePlayPause,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Icon(
                    _isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ],
                ],
              ),
            )
                : CircularProgressIndicator(),
          ),
        ),
        if (_controller.value.isInitialized)
          VideoProgressIndicator(_controller, allowScrubbing: true),
          Column(
            children: [
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  _seekToRelativePosition(details.localPosition, context);
                },
                onTapDown: (details) {
                  _seekToRelativePosition(details.localPosition, context);
                },
                child: Container(
                  height: 10, // Increased height for the progress bar
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.white,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.fast_rewind, color: Colors.white),
                    onPressed: () {
                      final newPosition = _controller.value.position - Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fast_forward, color: Colors.white),
                    onPressed: () {
                      final newPosition = _controller.value.position + Duration(seconds: 10);
                      _controller.seekTo(newPosition);
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
