import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraControllerProvider extends ChangeNotifier {
  late CameraController _controller;

  CameraController get controller => _controller;

  void initializeController(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    await _controller.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}