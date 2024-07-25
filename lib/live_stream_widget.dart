import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class LiveStreamWidget extends StatefulWidget {
  final String streamUrl;

  LiveStreamWidget({required this.streamUrl});

  @override
  _LiveStreamWidgetState createState() => _LiveStreamWidgetState();
}

class _LiveStreamWidgetState extends State<LiveStreamWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                _buildControlsOverlay(),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: () {
                  final currentPosition = _controller.value.position;
                  final rewindPosition = Duration(seconds: currentPosition.inSeconds - 10);
                  _controller.seekTo(rewindPosition);
                },
              ),
              IconButton(
                icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                onPressed: () {
                  setState(() {
                    _isFullScreen = !_isFullScreen;
                    if (_isFullScreen) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                    } else {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
