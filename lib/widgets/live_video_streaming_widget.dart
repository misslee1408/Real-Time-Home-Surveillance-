import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:real_time_home_surveillance_system/providers/camera_controller_provider.dart'; // Import Provider if you're using it for state management

class LiveVideoStreamingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraControllerProvider>(context);
    
    return cameraProvider.controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: cameraProvider.controller.value.aspectRatio,
            child: CameraPreview(cameraProvider.controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
