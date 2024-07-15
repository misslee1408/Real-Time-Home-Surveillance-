import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:real_time_home_surveillance_system/providers/camera_controller_provider.dart'; 

class LiveVideoStreamingWidget extends StatefulWidget {
  @override
  _LiveVideoStreamingWidgetState createState() => _LiveVideoStreamingWidgetState();
}

class _LiveVideoStreamingWidgetState extends State<LiveVideoStreamingWidget> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network('http://<raspberry-pi-ip>:<port>/video_feed')
      ..initialize().then((_) {
        setState(() {
          _isPlaying = false;
        });
      }).catchError((error) {
        print("Error initializing video player: $error");
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isInitialized) {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
        } else {
          _videoController.play();
        }
        _isPlaying = _videoController.value.isPlaying;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraControllerProvider>(context);

    return cameraProvider.controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: cameraProvider.controller.value.aspectRatio,
                child: CameraPreview(cameraProvider.controller),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.black,
                child: Center(
                  child: _videoController.value.isInitialized
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                                color: Colors.white,
                                size: 50.0,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                          ],
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              if (_videoController.value.isInitialized)
                VideoProgressIndicator(_videoController, allowScrubbing: true),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
