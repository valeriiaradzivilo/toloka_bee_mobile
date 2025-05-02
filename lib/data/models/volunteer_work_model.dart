import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/volunteer_work_model.freezed.dart';
part '../../generated/data/models/volunteer_work_model.g.dart';

@freezed
class VolunteerWorkModel with _$VolunteerWorkModel {
  const factory VolunteerWorkModel({
    required final String id,
    required final String volunteerId,
    required final String requesterId,
    required final String requestId,
    required final DateTime startedAt,
    final DateTime? finishedAt,
    required final bool volunteerConfirmed,
    required final bool requesterConfirmed,
  }) = _VolunteerWorkModel;

  factory VolunteerWorkModel.fromJson(final Map<String, dynamic> json) =>
      _$VolunteerWorkModelFromJson(json);
}
