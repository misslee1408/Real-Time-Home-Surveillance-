import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surveillance_system/screens/CameraControlWidget%20.dart';
import 'package:surveillance_system/screens/LiveVideoStreamingWidget%20.dart';
import 'package:surveillance_system/screens/MotionDetectionWidget.dart';
import 'package:surveillance_system/screens/RecordingPlaybackWidget.dart';
import 'package:surveillance_system/screens/SecurityPrivacyWidget.dart';

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
            CameraControlWidget(),
            MotionDetectionWidget(),
            RecordingPlaybackWidget(),
            SecurityPrivacyWidget(),
          ],
        ),
      ),
    );
  }
}
