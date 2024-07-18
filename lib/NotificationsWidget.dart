import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'NotificationsProvider .dart';
import 'package:intl/intl.dart';

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when the widget initializes
    Provider.of<NotificationsProvider>(context, listen: false)
        .fetchNotificationsFromSensor();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        return notificationsProvider.notifications.isEmpty
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
          itemCount: notificationsProvider.notifications.length,
          itemBuilder: (context, index) {
            final notification =
            notificationsProvider.notifications[index];
            return Card(
              margin:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  notification['message']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(
                    DateTime.parse(notification['date']!),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      notificationsProvider.deleteNotification(index),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
