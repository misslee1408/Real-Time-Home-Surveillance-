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

  Future<void> _deleteCamera(int id) async {
    try {
      await ApiService().deleteCamera(id);
      // After deleting, refresh the list of cameras
      _refreshCameras();
    } catch (e) {
      // Handle error
      print('Error deleting camera: $e');
    }
  }

  void _showDeleteConfirmation(BuildContext context, int cameraId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Camera'),
          content: Text('Are you sure you want to delete this camera?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteCamera(cameraId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cameras')),
      body: FutureBuilder<List<Camera>>(
        future: futureCameras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cameras'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cameras available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Camera camera = snapshot.data![index];
              return ListTile(
                title: Text(camera.name),
                subtitle: Text(camera.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: camera.isActive,
                      onChanged: (value) {
                        // Handle switch toggle if needed
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmation(context, camera.id);
                      },
                    ),
                  ],
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
