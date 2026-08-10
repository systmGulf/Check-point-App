import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final StreamController<NotificationResponse> streamController =
      StreamController<NotificationResponse>.broadcast();
  static bool _isInitialized = false;

  static void ontap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    if (_isInitialized) return;

    const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: ontap,
        onDidReceiveBackgroundNotificationResponse: ontap);
    _isInitialized = true;
  }

  static Future<void> showBasicNotification(
      {required String massBody, required String title}) async {
    await init();

    const notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails('channel_id', 'channel_name',
          priority: Priority.high, importance: Importance.max),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      massBody,
      notificationDetails,
    );
  }

  static Future<void> showRepeatedNotification() async {
    await init();

    const notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails('channel_id', 'channel_name',
          priority: Priority.high, importance: Importance.max),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
        1, '', "", RepeatInterval.hourly, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> deleteNotification(int id) {
    return flutterLocalNotificationsPlugin.cancel(id);
  }
}
