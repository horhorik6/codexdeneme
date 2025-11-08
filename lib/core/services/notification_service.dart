import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> subscribeToMatchNotifications() async {
    await _messaging.subscribeToTopic('amedspor_matches');
  }

  Future<void> subscribeToNewsNotifications() async {
    await _messaging.subscribeToTopic('amedspor_news');
  }

  Future<void> unsubscribeFromNewsNotifications() async {
    await _messaging.unsubscribeFromTopic('amedspor_news');
  }

  Future<void> unsubscribeFromMatchNotifications() async {
    await _messaging.unsubscribeFromTopic('amedspor_matches');
  }

  Future<void> sendTestNotification() async {
    debugPrint('Test notification triggered');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground notification: ${message.notification?.title}');
  }
}
