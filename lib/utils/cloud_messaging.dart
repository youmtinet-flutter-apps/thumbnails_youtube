import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final String? fCMToken = await _firebaseMessaging.getToken();
    log('Token: $fCMToken ');
    FirebaseMessaging.onMessage.listen(
      (event) {
        log('Token: $event ');
        log('Token: ${event.notification?.title} ');
        log('Token: ${event.notification?.body} ');
        log('Token: ${event.notification?.android?.imageUrl} ');
        log('Token: ${event.data} ');
      },
    );
  }

// function to handle received messages
  Future<void> handleMessage(RemoteMessage message) async {
    log(message.messageType ?? '');
  }

// function to initialize foreground and background settings
  Future<void> initNotofications() async {
    _firebaseMessaging.getInitialMessage().then((value) => handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }
}
