import 'package:flutter/material.dart';
import 'package:real_time_home_surveillance_system/widgets/live_video_streaming_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surveillance System'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LiveVideoStreamingWidget(),
            // CameraControlWidget(),
            // MotionDetectionWidget(),
            // RecordingPlaybackWidget(),
            // SecurityPrivacyWidget(),
          ],
        ),
      ),
    );
  }
}