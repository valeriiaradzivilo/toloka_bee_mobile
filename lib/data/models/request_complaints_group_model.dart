import 'package:freezed_annotation/freezed_annotation.dart';

import 'request_complaint_model.dart';

part '../../generated/data/models/request_complaints_group_model.freezed.dart';
part '../../generated/data/models/request_complaints_group_model.g.dart';

@freezed
class RequestComplaintsGroupModel with _$RequestComplaintsGroupModel {
  factory RequestComplaintsGroupModel({
    required final String requestId,
    required final int totalComplaints,
    required final List<RequestComplaintModel> complaints,
  }) = _RequestComplaintsGroupModel;

  factory RequestComplaintsGroupModel.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _$RequestComplaintsGroupModelFromJson(json);
}
