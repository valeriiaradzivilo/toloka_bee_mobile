import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../common/constants/location_constants.dart';
import '../../common/routing/routes.dart';
import '../models/request_notification_model.dart';
import '../models/ui/e_popup_type.dart';
import '../models/ui/popup_model.dart';
import 'snackbar_service.dart';

class FcmService {
  FcmService(final GetIt serviceLocator)
      : _snackbarService = serviceLocator<SnackbarService>() {
    initializeNotifications();
  }

  final SnackbarService _snackbarService;

  static final SimpleLogger _logger = SimpleLogger();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      LocationConstants.androidLocationChannelId,
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showLocalNotification({
    required final String title,
    required final String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      LocationConstants.androidLocationChannelId,
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      10000000,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void listenToMessages() async {
    FirebaseMessaging.onMessage.listen(_firebaseMessagingHandler);
  }

  void listenToBackgroundMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingHandler);
  }

  void stopListeningToMessages() {
    FirebaseMessaging.onMessage.listen((final _) {});
    FirebaseMessaging.onBackgroundMessage((final _) async {});
  }

  ///
  /// Private handlers
  ///

  Future<void> _firebaseMessagingHandler(
    final RemoteMessage message,
  ) async {
    final messageData = message.data;

    final title = message.notification?.title;
    final body = message.notification?.body;

    _logger.info('🔕 Фонове повідомлення: ${message.messageId}');
    _logger.info('📲 Отримано повідомлення у Background:');
    _logger.info('🔔 Заголовок: $title');
    _logger.info('📝 Тіло: $body');
    _logger.info('📦 Дані: ${message.data}');

    if (messageData['location'] != null) {
      final data = RequestNotificationModel.fromFCM(messageData);

      if (data.userId == FirebaseAuth.instance.currentUser?.uid) {
        return;
      }

      await _handleRequestNearbyNotification(
        data: data,
        title: title,
        body: body,
      );
      return;
    }

    if (title != null || body != null) {
      _snackbarService.show(
        PopupModel(
          title: title != null ? translate(title) : '',
          message: body,
          onPressed: (final BuildContext context) {
            Navigator.of(context).pushNamed(
              Routes.requestDetailsScreen,
              arguments: message.from,
            );
          },
        ),
      );
    }
  }

  Future<void> _handleRequestNearbyNotification({
    required final RequestNotificationModel data,
    required final String? title,
    required final String? body,
  }) async {
    final Position position = await Geolocator.getCurrentPosition();

    final double distanceKm = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          data.latitude,
          data.longitude,
        ) /
        1000;

    //TODO: Add ability to set distance in profile
    if (distanceKm > 100) return;

    _snackbarService.show(
      PopupModel(
        title: title ?? '',
        message: '${body ?? ''} ${translate(
          'request.details.distance',
          args: {
            'distance': distanceKm.toStringAsFixed(2),
          },
        )} ',
        onPressed: (final BuildContext context) {
          Navigator.of(context).pushNamed(
            Routes.requestDetailsScreen,
            arguments: data.id,
          );
        },
        type: EPopupType.helpNeeded,
      ),
    );
  }
}
