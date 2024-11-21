import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final String? fCMToken = await _firebaseMessaging.getToken();
    log('Token: $fCMToken ');
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
// dl6Wk_YsTlOUFh0H2cFmEr:APA91bH24c-zdcQJt317qxTeOOSriywQq-yz1p0N8IpG2UuzVIOBfAR82za4P4ebFBS5J7-b4VRSf2upjSH8Mqat_gbktU4TGKLtrcxqkwhI8MsyhJLEj0lsOX0SF2IEZ8cajgUyI_v_

// eXvGTAm2S-2taEjixfIl-p:APA91bFXT3SsBsz3rnTgcENDSoyeJA5Apy5uDBAlCN3xh9AvKZXnz1c6CG0Hiab__8NrqHhG1usYZkErjAa9Kp5szk0qg1XvsUeu9gWpN-ssjrITh12n7AMi6VvTOlQV_38Alcz4EyTT