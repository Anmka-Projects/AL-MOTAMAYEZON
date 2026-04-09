import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

GlobalMethods globalMethods = GlobalMethods();

class GlobalMethods {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isRegisteringNotification = false;
  bool _isNotificationRegistered = false;
  Future<void>? _permissionFuture;


  Future<void> registerNotification(context) async {
    if (_isNotificationRegistered) return;
    if (_isRegisteringNotification) return;
    _isRegisteringNotification = true;
    try {
      _permissionFuture ??= firebaseMessaging.requestPermission();
      try {
        await _permissionFuture;
      } catch (e) {
        debugPrint('Firebase permission request failed: $e');
      } finally {
        _permissionFuture = null;
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          configureLocalNotifications(message, context);
          showLocalNotification(message.notification ?? const RemoteNotification());
      });

      firebaseMessaging.getToken().then((token) {
        if (token != null) {
          debugPrint('token ================================> $token');
        }
      }).catchError((error) {
        // AppFunctions.showsToast(error.toString(), ColorManager.red, context);
      });
      _isNotificationRegistered = true;
    } finally {
      _isRegisteringNotification = false;
    }
  }

  void configureLocalNotifications(RemoteMessage message, context) {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iOSInitializationSettings = const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('message ==================> ${message.data.toString()}');
      },
    );
  }

   void showLocalNotification(RemoteNotification remoteNotification) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "com.services.fixman",
      "fixman",
      playSound: false,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
      presentSound: false,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      remoteNotification.hashCode,
      remoteNotification.title,
      remoteNotification.body,
      notificationDetails,
      payload: null,
    );
  }
}
