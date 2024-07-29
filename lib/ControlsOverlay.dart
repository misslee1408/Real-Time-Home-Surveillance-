import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CameraFeedWidget extends StatefulWidget {
  final String title;
  final String videoUrl;
  final Function onPlay;

  const CameraFeedWidget({
    Key? key,
    required this.title,
    required this.videoUrl, required void Function(String cameraUrl) toggleRecording, required this.onPlay,
  }) : super(key: key);

  @override
  _CameraFeedWidgetState createState() => _CameraFeedWidgetState();
}

class _CameraFeedWidgetState extends State<CameraFeedWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.videoUrl,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
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
