import '../../../../data/models/user_auth_model.dart';

sealed class UserProfileState {
  const UserProfileState();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

class UserProfileError extends UserProfileState {
  final String message;
  const UserProfileError(this.message);
}

class UserProfileLoaded extends UserProfileState {
  final UserAuthModel userAuthModel;
  const UserProfileLoaded(this.userAuthModel);
}
