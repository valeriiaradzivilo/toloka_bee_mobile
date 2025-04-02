import 'package:firebase_messaging/firebase_messaging.dart';

class FcmDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getFcmToken() async =>
      await _firebaseMessaging.getToken() ?? '';

  Future<void> subscribeToTopic(final String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
}
