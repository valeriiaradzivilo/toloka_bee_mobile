import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/request_complaint_model.freezed.dart';
part '../../generated/data/models/request_complaint_model.g.dart';

@freezed
class RequestComplaintModel with _$RequestComplaintModel {
  factory RequestComplaintModel({
    required final String id,
    required final String reporterUserId,
    required final String requestId,
    required final String reason,
    required final String createdAt,
  }) = _RequestComplaintModel;

  factory RequestComplaintModel.fromJson(final Map<String, dynamic> json) =>
      _$RequestComplaintModelFromJson(json);
}
