import 'dart:typed_data';

import '../../../common/list_extension.dart';
import '../../../data/models/contact_info_model.dart';
import '../../../data/models/request_notification_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/models/volunteer_work_model.dart';

sealed class RequestDetailsState {
  const RequestDetailsState();
}

final class RequestDetailsLoading extends RequestDetailsState {
  const RequestDetailsLoading();
}

final class RequestDetailsLoaded extends RequestDetailsState {
  const RequestDetailsLoaded({
    required this.requestNotificationModel,
    required this.distance,
    required this.requester,
    required this.image,
    required this.isCurrentUsersRequest,
    required this.volunteers,
    required this.volunteerWorks,
    required this.requesterContactInfo,
    required this.volunteerWorkModelCurrentUser,
  });
  final RequestNotificationModel requestNotificationModel;
  final List<VolunteerWorkModel> volunteerWorks;
  final VolunteerWorkModel? volunteerWorkModelCurrentUser;
  final List<UserAuthModel> volunteers;
  final double distance;
  final UserAuthModel requester;
  final ContactInfoModel? requesterContactInfo;
  final Uint8List image;
  final bool isCurrentUsersRequest;

  bool get isCurrentUserVolunteerForRequest =>
      volunteerWorkModelCurrentUser != null;

  bool get areVolunteersPresent =>
      volunteers.isNotEmpty && volunteerWorks.isNotEmpty;

  List<String> get allWorksIds =>
      volunteerWorks.map((final e) => e.id).toList();

  VolunteerWorkModel? fromVolunteerId(final String volunteerId) =>
      volunteerWorks.firstWhereOrNull(
        (final work) => work.volunteerId == volunteerId,
      );
}

final class RequestDetailsError extends RequestDetailsState {
  const RequestDetailsError({
    required this.error,
  });
  final String error;
}
