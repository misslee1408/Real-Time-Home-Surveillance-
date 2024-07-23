import 'package:flutter/material.dart';
import 'CameraControlWidget.dart';
import 'api_service.dart';
import 'live_stream_screen.dart'; // Import the live stream screen

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late Future<List<Camera>> futureCameras;

  @override
  void initState() {
    super.initState();
    _refreshCameras();
  }

  void _refreshCameras() {
    setState(() {
      futureCameras = ApiService().getCameras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cameras')),
      body: FutureBuilder<List<Camera>>(
        future: futureCameras,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Camera camera = snapshot.data![index];
                return ListTile(
                  title: Text(camera.name),
                  subtitle: Text(camera.location),
                  trailing: Switch(
                    value: camera.isActive,
                    onChanged: (value) {
                      // Handle switch toggle if needed
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveStreamScreen(camera: camera),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cameras'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add camera screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCameraScreen()),
          );
          if (result == true) {
            _refreshCameras(); // Refresh the list after adding a new camera
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
