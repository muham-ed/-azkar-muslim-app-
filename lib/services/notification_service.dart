import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'azkar_channel',
        'أذكار وتنبيهات المسلم',
        channelDescription: 'تنبيهات أذكار الصباح والمساء ومواقيت الصلاة',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
