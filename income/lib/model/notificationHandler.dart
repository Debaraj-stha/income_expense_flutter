import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:income/pages/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

void Demo() {
  print("demo is called");
}

class NotificationHandler {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void RefreshToken() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void RequestPermission() async {
    NotificationSettings status = await messaging.requestPermission();
    if (status.authorizationStatus == AuthorizationStatus.authorized) {
      print("grantyed");
    } else {
      print("not granted permission");
    }
  }

  Future<void> initMessage(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.toMap());
      if (Platform.isAndroid) {
        initNotification(context, event);
        showNotification(context, event);
      } else {
        showNotification(context, event);
      }
    });
  }

  void initNotification(BuildContext context, RemoteMessage message) async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void showNotification(BuildContext context, RemoteMessage message) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
            priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(presentBadge: true, presentAlert: true);
    NotificationDetails details = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    notificationsPlugin.show(
        1, message.notification!.title, message.notification!.body, details);
  }

  void interactMessage(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleMessage(context, message);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      final data = message.data;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  // void scheduleNotification(String to) async {
  //   print("called scheduleNotification");
  //   final now = tz.TZDateTime.now(tz.local);

  //   tz.TZDateTime scheduledTime = tz.TZDateTime(
  //     tz.local,
  //     now.year,
  //     now.month,
  //     now.day,
  //     11,
  //     10,
  //   );

  //   if (now.isAfter(scheduledTime)) {
  //     scheduledTime = scheduledTime.add(const Duration(days: 1));
  //   }
  //   print(scheduledTime);

  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     priority: Priority.max,
  //     importance: Importance.max,
  //   );
  //   const DarwinNotificationDetails darwinNotificationDetails =
  //       DarwinNotificationDetails(presentBadge: true, presentAlert: true);
  //   const NotificationDetails details = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: darwinNotificationDetails,
  //   );

  //   await notificationsPlugin.zonedSchedule(
  //     1,
  //     "Scheduled  Title",
  //     "Scheduled  Body",
  //     scheduledTime,
  //     details,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );

  //   sendNotification(to);
  // }

   sendNotification(String to) async {
    print("\n\n\n\n\n\n\n\n\n");
    print("send notification called");
    print(to);
    String key =
        "AAAAw-tixzc:APA91bFqfKj3GL1AjieEgv38XrmwP8ac3M0JrNeP54mz_ec3gT8PigwpER7A5r-kSerdPBVuLaQ6sAoW59vi6kH5n_7JaL6WJZjkxd0kw9rk8FcLOIZKdwGNDWfC5DPzfRSWJKjR8_Ks";
    var data = {
      "to": to,
      "priority": "high",
      "notification": {
        "title": "Greeting",
        "body": "Hello there",
      },
      "data": {
        "message": "message ",
        "type": "msg",
      }
    };
    print("before http request");
    final response = await http.post(
        // Uri.parse("https://jsonplaceholder.typicode.com/todos/1")
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'key=$key'
        });
    
    print(response.body);
    print("after http request");
    print("response${response.statusCode}");
  }
}
