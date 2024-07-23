import 'package:flutter/material.dart';
import 'api_service.dart';

class LiveStreamScreen extends StatelessWidget {
  final Camera camera;

  LiveStreamScreen({required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Stream: ${camera.name}'),
      ),
      body: Center(
        child: Text('Live stream for ${camera.name} at ${camera.streamurl}'),
        // You can use a video player package like `video_player` to stream the video
      ),
    );
  }
}
