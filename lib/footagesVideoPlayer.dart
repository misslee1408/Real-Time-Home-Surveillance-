import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FootagePlayerPage extends StatefulWidget {
  final String fileName;

  FootagePlayerPage({required this.fileName});

  @override
  _FootagePlayerPageState createState() => _FootagePlayerPageState();
}

class _FootagePlayerPageState extends State<FootagePlayerPage> { 
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'http://localhost:3000/api/footages/${widget.fileName}',
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileName)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      bottomNavigationBar: _controller.value.isInitialized
          ? BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.replay_10),
                    onPressed: () => _rewind(),
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10),
                    onPressed: () => _forward(),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _rewind() {
    final position = _controller.value.position;
    final rewindPosition = position - Duration(seconds: 2);
    _controller.seekTo(rewindPosition > Duration.zero ? rewindPosition : Duration.zero);
  }

  void _forward() {
    final position = _controller.value.position;
    final forwardPosition = position + Duration(seconds: 2);
    final duration = _controller.value.duration;
    _controller.seekTo(forwardPosition < duration ? forwardPosition : duration);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
