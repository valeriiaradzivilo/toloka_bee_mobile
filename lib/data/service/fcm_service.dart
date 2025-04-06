import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../common/constants/location_constants.dart';
import '../../common/routes.dart';
import '../../common/widgets/zip_snackbar.dart';
import '../../main.dart';
import '../models/request_notification_model.dart';
import '../models/ui/e_popup_type.dart';
import '../models/ui/popup_model.dart';

class FcmService {
  FcmService() {
    initializeNotifications();
  }

  static final SimpleLogger _logger = SimpleLogger();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      LocationConstants.androidLocationChannelId,
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void listenToMessages() async {
    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
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

    final context = MyApp.navigatorKey.currentState?.context;

    if (context == null) {
      _logger.warning('❌ Контекст не знайдено');
      return;
    }

    final data = RequestNotificationModel.fromJson(message.data);

    ZipSnackbar.show(
      context,
      PopupModel(
        title: message.notification?.title ?? '',
        message: message.notification?.body ?? '',
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.requestDetailsScreen,
            arguments: data,
          );
        },
        type: EPopupType.helpNeeded,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔔 ${message.notification?.title} - ${message.notification?.body}',
        ),
      ),
    );
  }
}
