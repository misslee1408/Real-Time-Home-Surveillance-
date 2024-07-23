import 'package:flutter/material.dart';
import 'api_service.dart';

class CameraListScreen extends StatefulWidget {
  @override
  _CameraListScreenState createState() => _CameraListScreenState();
}

class _CameraListScreenState extends State<CameraListScreen> {
  late Future<List<Camera>> futureCameras;

  @override
  void initState() {
    super.initState();
    futureCameras = ApiService().getCameras();
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
                    onChanged: (value) {},
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cameras'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
