import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/constants/location_constants.dart';
import '../../di.dart';
import '../../models/request_notification_model.dart';
import '../authentication/auth_data_source.dart';

class FcmDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FcmDataSource(this._dio);
  final Dio _dio;

  final String _basePath = '/request';

  Future<String> getFcmToken() async =>
      await _firebaseMessaging.getToken() ?? '';

  Future<void> subscribeToTopic(final String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(final String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> sendNotification(
    final RequestNotificationModel notification,
  ) async {
    final apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
    }

    final postUrl =
        'https://fcm.googleapis.com/v1/projects/zip-way/messages:send';

    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final location = LatLng(notification.latitude, notification.longitude);

    final payload = {
      'message': {
        'topic': location.locationTopic,
        'notification': {
          'title': 'Somebody needs your help',
          'body': 'Open the app to see the details',
        },
        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': LocationConstants.androidLocationChannelId,
            'visibility': 'PUBLIC',
            'sound': 'default',
            'default_sound': true,
            'default_vibrate_timings': true,
            'default_light_settings': true,
          },
        },
        'data': notification
            .toJson()
            .map((final key, final value) => MapEntry(key, value.toString())),
      },
    };

    final response = await _dio.post(
      postUrl,
      options: Options(headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      final result = await _dio.post(
        '$_basePath/save',
        options: Options(headers: headers),
        data: jsonEncode(
          notification.copyWith(id: response.data['name']).toJson(),
        ),
      );
      if (result.statusCode != 200) {
        throw Exception(
          'Failed to save notification: ${result.statusCode}',
        );
      }
    } else {
      throw Exception(
        'Failed to send notification: ${response.statusCode}',
      );
    }
  }
}
