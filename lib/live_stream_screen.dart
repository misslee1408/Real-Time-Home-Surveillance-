import 'package:flutter/material.dart';
import 'live_stream_widget.dart';
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
      body: LiveStreamWidget(streamUrl: camera.streamurl),
    );
  }
}
