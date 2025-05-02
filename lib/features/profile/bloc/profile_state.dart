import '../../../data/models/contact_info_model.dart';
import '../../../data/models/request_notification_model.dart';
import '../../../data/models/user_auth_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserAuthModel user;
  final List<RequestNotificationModel> requests;
  final List<RequestNotificationModel> volunteerWorks;
  final ContactInfoModel? contactInfo;

  const ProfileLoaded({
    required this.user,
    required this.requests,
    required this.volunteerWorks,
    required this.contactInfo,
  });

  ProfileLoaded copyWith({
    final UserAuthModel? user,
    final List<RequestNotificationModel>? requests,
    final List<RequestNotificationModel>? volunteerWorks,
    final ContactInfoModel? contactInfo,
  }) =>
      ProfileLoaded(
        user: user ?? this.user,
        requests: requests ?? this.requests,
        volunteerWorks: volunteerWorks ?? this.volunteerWorks,
        contactInfo: contactInfo ?? this.contactInfo,
      );
}

class ProfileUpdating extends ProfileLoaded {
  final UserAuthModel changedUser;
  final String? oldPassword;

  ProfileUpdating({
    required this.changedUser,
    this.oldPassword,
  }) : super(
          user: changedUser,
          requests: const [],
          volunteerWorks: const [],
          contactInfo: null,
        );

  @override
  ProfileUpdating copyWith({
    final UserAuthModel? user,
    final List<RequestNotificationModel>? requests,
    final List<RequestNotificationModel>? volunteerWorks,
    final ContactInfoModel? contactInfo,
    final String? oldPassword,
  }) =>
      ProfileUpdating(
        changedUser: user ?? changedUser,
        oldPassword: oldPassword ?? this.oldPassword,
      );
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}

class ProfileUpdated extends ProfileState {
  final UserAuthModel user;

  const ProfileUpdated(this.user);
}
