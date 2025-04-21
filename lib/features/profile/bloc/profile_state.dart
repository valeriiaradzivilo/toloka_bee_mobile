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
  final ContactInfoModel? contactInfo;

  const ProfileLoaded({
    required this.user,
    required this.requests,
    required this.contactInfo,
  });
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating({
    required this.changedUser,
    this.oldPassword,
  });

  final UserAuthModel changedUser;
  final String? oldPassword;

  ProfileUpdating copyWith({
    final UserAuthModel? changedUser,
    final String? oldPassword,
  }) =>
      ProfileUpdating(
        changedUser: changedUser ?? this.changedUser,
        oldPassword: oldPassword ?? this.oldPassword,
      );
}

class ProfileUpdated extends ProfileState {
  final UserAuthModel user;
  const ProfileUpdated(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
