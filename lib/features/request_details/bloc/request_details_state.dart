import 'dart:typed_data';

import '../../../data/models/request_notification_model.dart';
import '../../../data/models/user_auth_model.dart';

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
    required this.user,
    required this.image,
    required this.isCurrentUsersRequest,
    required this.isCurrentUserVolunteerForRequest,
    this.volunteers = const [],
  });
  final RequestNotificationModel requestNotificationModel;
  final List<UserAuthModel> volunteers;
  final double distance;
  final UserAuthModel user;
  final Uint8List image;
  final bool isCurrentUsersRequest;
  final bool isCurrentUserVolunteerForRequest;
}

final class RequestDetailsError extends RequestDetailsState {
  const RequestDetailsError({
    required this.error,
  });
  final String error;
}
