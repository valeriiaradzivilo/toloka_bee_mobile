import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:simple_logger/simple_logger.dart';

class FcmService {
  FcmService(this._dio);
  final Dio _dio;

  static final SimpleLogger _logger = SimpleLogger();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM(final String userId) async {
    // 1. Запит на дозволи
    final NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.info('✅ Дозвіл на сповіщення надано');

      // 2. Отримуємо токен
      final String? token = await _messaging.getToken();
      _logger.info('🔑 FCM Token: $token');

      if (token != null) {}
    } else {
      _logger.info('🚫 Дозвіл на сповіщення не надано');
    }
  }

  void listenToMessages() async {
    await FirebaseMessaging.instance.subscribeToTopic('test');
    FirebaseMessaging.onMessage.listen((final RemoteMessage message) {
      _logger.info('🔕 Фонове повідомлення: ${message.messageId}');
      _logger.info('📲 Отримано повідомлення у Foreground:');
      _logger.info('🔔 Заголовок: ${message.notification?.title}');
      _logger.info('📝 Тіло: ${message.notification?.body}');
      _logger.info('📦 Дані: ${message.data}');
    });
  }

  void listenToBackgroundMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    final RemoteMessage message,
  ) async {
    _logger.info('🔕 Фонове повідомлення: ${message.messageId}');
    _logger.info('📲 Отримано повідомлення у Background:');
    _logger.info('🔔 Заголовок: ${message.notification?.title}');
    _logger.info('📝 Тіло: ${message.notification?.body}');
    _logger.info('📦 Дані: ${message.data}');
  }
}
