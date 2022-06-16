import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:master_car_project/controller/notifiers/load_notification_notifier.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../ui/notification_screen.dart';
import 'local_notification_service.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  // if (message.data.containsKey('data')) {}
  // if (message.data.containsKey('notification')) {}
}

class FCM {
  setNotification() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    //app is active
    foregroundNotifications();

    //app running in background
    backgroundNotifications();

    //app closed
    terminatedNotifications();
  }

  //app is in the background
  backgroundNotifications() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(navigatorKey.currentState!.context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()));
      // }
    });
  }

  //app is closed
  terminatedNotifications() async {
    dynamic initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        ),
      );
    }
  }

  // app is active
  foregroundNotifications() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'channel',
            channelDescription: 'description',
            priority: Priority.max,
            enableVibration: true,
            playSound: true,
            importance: Importance.max);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    FirebaseMessaging.onMessage.listen((dynamic message) async {
      print('i am open');

      if (LocalNotificationService.x == 1) {
        navigatorKey.currentState?.context
            .read<LoadNotificationController>()
            .loadNotification();
      } else {
        await flutterLocalNotificationsPlugin.show(
            1,
            message.notification!.title,
            message.notification!.body,
            platformChannelSpecifics,
            payload: "");
      }
    });
  }
}
