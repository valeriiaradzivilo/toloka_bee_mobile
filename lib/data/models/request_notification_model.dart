import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/request_notification_model.freezed.dart';
part '../../generated/data/models/request_notification_model.g.dart';

@freezed
class RequestNotificationModel with _$RequestNotificationModel {
  const factory RequestNotificationModel({
    required final String id,
    required final String requestId,
    required final String userId,
    required final String status,
    required final DateTime deadline,
    required final double latitude,
    required final double longitude,
    required final bool isRemote,
    required final bool requiresPhysicalStrength,
    required final int? price,
    required final String description,
  }) = _RequestNotificationModel;

  factory RequestNotificationModel.fromJson(final Map<String, dynamic> json) =>
      _$RequestNotificationModelFromJson(json);
}
