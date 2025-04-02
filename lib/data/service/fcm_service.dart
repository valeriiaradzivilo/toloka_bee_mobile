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

      if (token != null) {
        // 3. Відправляємо на бекенд
        await _dio.post(
          'https://твій_бекенд/api/save-fcm-token',
          data: {
            'userId': userId,
            'fcmToken': token,
          },
        );
      }
    } else {
      print('🚫 Дозвіл на сповіщення не надано');
    }
  }

  void listenToMessages() {
    FirebaseMessaging.onMessage.listen((final RemoteMessage message) {
      print('🔕 Фонове повідомлення: ${message.messageId}');
      print('📲 Отримано повідомлення у Foreground:');
      print('🔔 Заголовок: ${message.notification?.title}');
      print('📝 Тіло: ${message.notification?.body}');
      print('📦 Дані: ${message.data}');
    });
  }
}
