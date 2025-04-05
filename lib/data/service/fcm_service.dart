import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Dio _dio = Dio(); // або кастомний

  Future<void> initFCM(final String userId) async {
    // 1. Запит на дозволи
    final NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Дозвіл на сповіщення надано');

      // 2. Отримуємо токен
      final String? token = await _messaging.getToken();
      print('🔑 FCM Token: $token');

      if (token != null) {}
    } else {
      print('🚫 Дозвіл на сповіщення не надано');
    }
  }

  void listenToMessages() async {
    await FirebaseMessaging.instance.subscribeToTopic('test');
    FirebaseMessaging.onMessage.listen((final RemoteMessage message) {
      print('🔕 Фонове повідомлення: ${message.messageId}');
      print('📲 Отримано повідомлення у Foreground:');
      print('🔔 Заголовок: ${message.notification?.title}');
      print('📝 Тіло: ${message.notification?.body}');
      print('📦 Дані: ${message.data}');
    });
  }

  void listenToBackgroundMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    final RemoteMessage message,
  ) async {
    print('🔕 Фонове повідомлення: ${message.messageId}');
    print('📲 Отримано повідомлення у Background:');
    print('🔔 Заголовок: ${message.notification?.title}');
    print('📝 Тіло: ${message.notification?.body}');
    print('📦 Дані: ${message.data}');
  }
}
