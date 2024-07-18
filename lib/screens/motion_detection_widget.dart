import 'package:flutter/material.dart';

class MotionDetectionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text('Motion Detection'),
        SwitchListTile(
          title: Text('Enable Motion Detection'),
          value: true,
          onChanged: (bool value) {
            // Add motion detection functionality
          },
        ),
        ElevatedButton(
          onPressed: () {
            // Add motion detection alerts functionality
          },
          child: Text('Show Alerts'),
        ),
      ],
    );
  }
}