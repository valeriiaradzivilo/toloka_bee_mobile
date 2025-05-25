import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/data/models/complaints/user_complaint_model.freezed.dart';
part '../../../generated/data/models/complaints/user_complaint_model.g.dart';

@freezed
class UserComplaintModel with _$UserComplaintModel {
  factory UserComplaintModel({
    @JsonKey(includeFromJson: true, includeToJson: false)
    required final String id,
    required final String reporterUserId,
    required final String reportedUserId,
    required final String reason,
    required final String createdAt,
  }) = _UserComplaintModel;

  factory UserComplaintModel.fromJson(final Map<String, dynamic> json) =>
      _$UserComplaintModelFromJson(json);
}
