import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraControllerProvider extends ChangeNotifier {
  late CameraController _controller;

  CameraController get controller => _controller;

  CameraControllerProvider(CameraDescription cameraDescription) {
    initializeController(cameraDescription);
  }

  void initializeController(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    await _controller.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
