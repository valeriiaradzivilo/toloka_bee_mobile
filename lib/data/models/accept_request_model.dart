import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/accept_request_model.freezed.dart';
part '../../generated/data/models/accept_request_model.g.dart';

@freezed
class AcceptRequestModel with _$AcceptRequestModel {
  const factory AcceptRequestModel({
    required final String requestId,
    required final String volunteerId,
    required final String status,
  }) = _AcceptRequestModel;

  factory AcceptRequestModel.fromJson(final Map<String, dynamic> json) =>
      _$AcceptRequestModelFromJson(json);
}
