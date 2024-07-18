import 'package:flutter/material.dart';

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  List<Map<String, String>> notifications = [
    {'date': '2024-07-15 10:00', 'message': 'Motion detected'},
    {'date': '2024-07-15 10:05', 'message': 'Camera offline'},
    {'date': '2024-07-15 09:30', 'message': 'New user registered'},
    // Add more notifications as needed
  ];

  @override
  void initState() {
    super.initState();
    // Sort notifications by date
    notifications.sort((a, b) => DateTime.parse(b['date']!).compareTo(DateTime.parse(a['date']!)));
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(
              notifications[index]['message']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              notifications[index]['date']!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteNotification(index),
            ),
          ),
        );
      },
    );
  }
}
