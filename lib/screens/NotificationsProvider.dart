import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  List<Map<String, String>> _notifications = [];

  List<Map<String, String>> get notifications => _notifications;

  // Function to fetch notifications from sensors or other sources
  Future<void> fetchNotificationsFromSensor() async {
    // Simulate fetching data from sensors or API
    // Replace with actual logic to fetch notifications dynamically
    await Future.delayed(Duration(seconds: 2)); // Simulate delay

    // Example of dynamic notifications
    List<Map<String, String>> fetchedNotifications = [
      {'date': '2024-07-15 10:00', 'message': 'Motion detected'},
      {'date': '2024-07-15 10:05', 'message': 'Camera offline'},
      {'date': '2024-07-15 09:30', 'message': 'New user registered'},
    ];

    // Update notifications and notify listeners
    _notifications = fetchedNotifications;
    notifyListeners();
  }

  void deleteNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }
}
