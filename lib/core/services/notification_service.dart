import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  Future<void> init() async {
    await _messaging.requestPermission();
    await _messaging.subscribeToTopic('amedspor');
  }

  Future<void> sendMatchNotification({required String title, required String body}) async {
    // Firebase Cloud Functions should trigger notifications.
    // This placeholder can be expanded with callable functions.
  }
}
