import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/constants/location_constants.dart';
import '../../di.dart';
import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';
import '../authentication/auth_data_source.dart';

class FcmDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FcmDataSource(this._dio);
  final Dio _dio;

  final String _basePathRequest = '/request';
  final String _basePathSubscription = '/location-subscription';

  Future<String> getFcmToken() async =>
      await _firebaseMessaging.getToken() ?? '';

  Future<void> subscribeToTopic(
    final LocationSubscriptionModel locationSubscription,
  ) async {
    await _firebaseMessaging.subscribeToTopic(locationSubscription.topic);
    final data = locationSubscription.toJson();
    await _dio.post(
      '$_basePathSubscription/subscribe',
      data: jsonEncode(data),
    );
  }

  Future<void> unsubscribeFromTopic(
    final LocationSubscriptionModel locationSubscription,
  ) async {
    await _firebaseMessaging.unsubscribeFromTopic(locationSubscription.topic);
    await _dio.post(
      '$_basePathSubscription/unsubscribe',
      data: jsonEncode(locationSubscription.toJson()),
    );
  }

  Future<void> sendNotification(
    final RequestNotificationModel notification,
  ) async {
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

    final notificationData = notification.toJson();

    final Map<String, String> data = {};
    notificationData.forEach((final key, final value) {
      if (key == 'location' && value is Map) {
        data[key] = jsonEncode(value);
      } else {
        data[key] = value.toString();
      }
    });

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
        'data': data,
      },
    };

    final response = await _dio.post(
      postUrl,
      options: Options(headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      final result = await _dio.post(
        '$_basePathRequest/save',
        options: Options(headers: headers),
        data: notificationData,
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

  Future<List<RequestNotificationModel>> getAllRequests(
    final GetRequestsModel location,
  ) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await _dio.get(
      '$_basePathRequest/get-all',
      options: Options(headers: headers),
      data: jsonEncode(location.toJson()),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((final e) => RequestNotificationModel.fromJson(e))
          .toList();
    } else {
      throw Exception(
        'Failed to get all requests: ${response.statusCode}',
      );
    }
  }

  Future<int> countVolunteersByTopic(
    final String topic,
  ) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await _dio.get(
      '$_basePathSubscription/count/$topic',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final volunteersSubscriptions = (response.data as List)
          .map((final e) => LocationSubscriptionModel.fromJson(e))
          .where(
            (final element) =>
                element.userId != FirebaseAuth.instance.currentUser?.uid,
          );
      return volunteersSubscriptions.length;
    } else {
      throw Exception(
        'Failed to count volunteers by topic: ${response.statusCode}',
      );
    }
  }

  Future<void> updateNotification(
    final RequestNotificationModel notification,
  ) async {
    throw UnimplementedError();
  }
}
