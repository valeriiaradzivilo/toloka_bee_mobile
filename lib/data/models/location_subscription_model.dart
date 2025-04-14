import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/location_subscription_model.freezed.dart';
part '../../generated/data/models/location_subscription_model.g.dart';

@freezed
class LocationSubscriptionModel with _$LocationSubscriptionModel {
  factory LocationSubscriptionModel({
    required final String id,
    required final String topic,
    required final String userId,
  }) = _LocationSubscriptionModel;

  factory LocationSubscriptionModel.fromJson(final Map<String, dynamic> json) =>
      _$LocationSubscriptionModelFromJson(json);
}
