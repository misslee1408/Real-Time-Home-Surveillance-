import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CameraControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Video Quality'),
          trailing: DropdownButton<String>(
            items: <String>['Low', 'Medium', 'High'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
        ListTile(
          title: Text('Magnify'),
          trailing: Icon(Icons.zoom_in),
          onTap: () {
            // Add magnify functionality
          },
        ),
        // more camera control options will be added here
      ],
    );
  }
}
