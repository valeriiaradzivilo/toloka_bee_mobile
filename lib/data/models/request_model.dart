import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/request_model.freezed.dart';
part '../../generated/data/models/request_model.g.dart';

@freezed
class RequestModel with _$RequestModel {
  const factory RequestModel({
    required final String description,
    required final DateTime deadline,
    required final bool isRemote,
    required final bool requiresPhysicalStrength,
    required final int? price,
  }) = _RequestModel;

  factory RequestModel.fromJson(final Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);
}
