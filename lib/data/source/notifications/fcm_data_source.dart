import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/request_notification_model.dart';

class FcmDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FcmDataSource(this._dio);
  final Dio _dio;

  final String serverKey =
      'BIMW3VLTV3S-6sBvkwKAvWEOvIIrbItxTOP1bwAo_5DVnH8VEYokiVMnvGevWYYov4hQgrcKnOsgc9Pf-sxX0BA';

  Future<String> getFcmToken() async =>
      await _firebaseMessaging.getToken() ?? '';

  Future<void> subscribeToTopic(final String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> sendNotification(
    final RequestNotificationModel notification,
  ) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': await getFcmToken(),
      'priority': 'high',
      'notification': {
        'title': 'Somebody needs your help',
        'body': 'Open the app to see the details',
      },
      'data': notification.toJson(),
    };

    final response = await _dio.post(
      postUrl,
      options: Options(headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      print('✅ Сповіщення успішно надіслано');
    } else {
      print('❌ Помилка при надсиланні: ${response.statusCode}');
      print(response.data);
    }
  }
}
