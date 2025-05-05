import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/constants/location_constants.dart';
import '../../di.dart';
import '../../models/accept_request_model.dart';
import '../../models/e_request_status.dart';
import '../../models/e_request_update.dart';
import '../../models/get_requests_model.dart';
import '../../models/location_subscription_model.dart';
import '../../models/request_notification_model.dart';
import '../authentication/auth_data_source.dart';
import 'fcm_data_source.dart';

class FcmDataSourceImpl implements FcmDataSource {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FcmDataSourceImpl(this._dio);
  final Dio _dio;

  final String _basePathRequest = '/request';
  final String _basePathSubscription = '/location-subscription';

  @override
  Future<String> getFcmToken() async =>
      await _firebaseMessaging.getToken() ?? '';

  @override
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

  @override
  Future<void> unsubscribeFromTopic(
    final LocationSubscriptionModel locationSubscription,
  ) async {
    await _firebaseMessaging.unsubscribeFromTopic(locationSubscription.topic);
    await _dio.post(
      '$_basePathSubscription/unsubscribe',
      data: jsonEncode(locationSubscription.toJson()),
    );
  }

  @override
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

    final title = notification.title;
    final body = notification.body;

    final payload = {
      'message': {
        'topic': location.locationTopic,
        'notification': {
          'title': title,
          'body': body,
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

  @override
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

    //TODO: Дороби personalized на беці

    final response = await _dio.post(
      '$_basePathRequest/get-personalized',
      options: Options(headers: headers),
      data: location.toJson(),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((final e) => RequestNotificationModel.fromJson(e))
          .where(
            (final element) => element.status.canBeHelped,
          )
          .toList();
    } else {
      throw Exception(
        'Failed to get all requests: ${response.statusCode}',
      );
    }
  }

  @override
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

  @override
  Future<void> updateRequest(
    final RequestNotificationModel notification,
  ) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await _dio.post(
      '$_basePathRequest/update',
      options: Options(headers: headers),
      data: notification.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update request: ${response.statusCode}',
      );
    }
  }

  @override
  Future<RequestNotificationModel> getRequestById(
    final String id,
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
      '$_basePathRequest/get/$id',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return RequestNotificationModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to get request by id: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> acceptRequest(
    final String id,
  ) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await _dio.post(
      '$_basePathRequest/accept',
      data: AcceptRequestModel(
        requestId: id,
        volunteerId: FirebaseAuth.instance.currentUser!.uid,
        status: ERequestStatus.inProgress.name.toLowerCase(),
      ).toJson(),
      options: Options(headers: headers),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to accept request: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deleteRequest(final String id) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await _dio.delete(
      '$_basePathRequest/delete/$id',
      options: Options(headers: headers),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete request: ${response.statusCode}',
      );
    }

    return;
  }

  @override
  Future<List<RequestNotificationModel>> getAllRequestsByUserId(
    final String userId,
  ) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    return _dio
        .get(
      '$_basePathRequest/get-by-user/$userId',
      options: Options(headers: headers),
    )
        .then((final response) {
      if (response.statusCode == 200) {
        final result = (response.data as List)
            .map((final e) => RequestNotificationModel.fromJson(e))
            .toList();

        if (userId == FirebaseAuth.instance.currentUser?.uid) {
          result.sort(
            (final a, final b) => a.status.compareTo(b.status),
          );
        }

        return result;
      } else {
        throw Exception(
          'Failed to get all requests by user id: ${response.statusCode}',
        );
      }
    });
  }

  @override
  Future<List<RequestNotificationModel>> getRequestsByIds(
    final List<String> ids,
  ) async {
    final accessToken = await serviceLocator<AuthDataSource>().getAccessToken();

    if (accessToken.isEmpty) {
      throw Exception('Access token is null');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await _dio.post(
      '$_basePathRequest/get-by-ids',
      options: Options(headers: headers),
      data: jsonEncode(ids),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((final e) => RequestNotificationModel.fromJson(e))
          .toList();
    } else {
      throw Exception(
        'Failed to get requests by ids: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> subscribeToRequestUpdates(final String requestId) async {
    await _firebaseMessaging.subscribeToTopic(requestId);
  }

  @override
  Future<void> unsubscribeFromRequestUpdates(final String requestId) async {
    await _firebaseMessaging.unsubscribeFromTopic(requestId);
  }

  @override
  Future<void> sendRequestUpdateNotification(
    final String requestId,
    final ERequestUpdate requestUpdate,
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

    final title = requestUpdate.text;

    final payload = {
      'message': {
        'topic': requestId,
        'notification': {
          'title': title,
          'body': '',
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
        'data': {},
      },
    };

    await _dio.post(
      postUrl,
      options: Options(headers: headers),
      data: payload,
    );
  }
}
