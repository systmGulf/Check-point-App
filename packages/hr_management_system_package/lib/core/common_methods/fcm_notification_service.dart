// import 'dart:async';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'local_notifications_service.dart';

// abstract class FcmNotificationService {
//   static Future<void> init() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     final currentFCMToken = await FirebaseMessaging.instance.getToken();
//     log(currentFCMToken.toString());
//     FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       LocalNotificationService.showBasicNotification(
//           massBody: message.notification!.body!,
//           title: message.notification!.title!);
//     });
//   }

//   static Future<void> backgroundMessageHandler(RemoteMessage message) async {}
// }
