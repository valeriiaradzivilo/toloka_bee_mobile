import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_complaint_model.dart';

part '../../../generated/data/models/complaints/user_complaints_group_model.freezed.dart';
part '../../../generated/data/models/complaints/user_complaints_group_model.g.dart';

@freezed
class UserComplaintsGroupModel with _$UserComplaintsGroupModel {
  factory UserComplaintsGroupModel({
    required final String reportedUserId,
    required final int totalComplaints,
    required final List<UserComplaintModel> complaints,
  }) = _UserComplaintsGroupModel;

  factory UserComplaintsGroupModel.fromJson(final Map<String, dynamic> json) =>
      _$UserComplaintsGroupModelFromJson(json);
}
