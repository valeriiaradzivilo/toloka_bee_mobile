import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/request_notification_model.freezed.dart';
part '../../generated/data/models/request_notification_model.g.dart';

@freezed
class RequestNotificationModel with _$RequestNotificationModel {
  const factory RequestNotificationModel({
    required final String id,
    required final String requestId,
    required final String targetFirebaseToken,
    required final String userId,
    required final String status,
    required final DateTime deadline,
    required final double latitude,
    required final double longitude,
  }) = _RequestNotificationModel;

  factory RequestNotificationModel.fromJson(final Map<String, dynamic> json) =>
      _$RequestNotificationModelFromJson(json);
}
