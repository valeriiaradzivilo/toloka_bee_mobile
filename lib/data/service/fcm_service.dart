// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../common/constants/location_constants.dart';
import '../../common/routing/routes.dart';
import '../../common/widgets/zip_snackbar.dart';
import '../../features/main_app/main_app.dart';
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
    final context = MainApp.navigatorKey.currentState?.context;

    if (context == null || !context.mounted) {
      _logger.warning('❌ Контекст не знайдено');
      return;
    }

    final data = RequestNotificationModel.fromFCM(message.data);

    if (data.userId == FirebaseAuth.instance.currentUser?.uid) {
      return;
    }

    _logger.info('🔕 Фонове повідомлення: ${message.messageId}');
    _logger.info('📲 Отримано повідомлення у Background:');
    _logger.info('🔔 Заголовок: ${message.notification?.title}');
    _logger.info('📝 Тіло: ${message.notification?.body}');
    _logger.info('📦 Дані: ${message.data}');

    final Position position = await Geolocator.getCurrentPosition();

    final double distanceKm = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          data.latitude,
          data.longitude,
        ) /
        1000;

    if (distanceKm > 100) return;

    ZipSnackbar.show(
      context,
      PopupModel(
        title: message.notification?.title ?? '',
        message: '${message.notification?.body ?? ''} ${translate(
          'request.details.distance',
          args: {
            'distance': distanceKm.toStringAsFixed(2),
          },
        )} ',
        onPressed: (final BuildContext context) {
          Navigator.of(context).pushNamed(
            Routes.requestDetailsScreen,
            arguments: data,
          );
        },
        type: EPopupType.helpNeeded,
      ),
    );
  }
}
