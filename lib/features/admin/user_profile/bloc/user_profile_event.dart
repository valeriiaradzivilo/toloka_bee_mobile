abstract class UserProfileEvent {
  const UserProfileEvent();
}

class GetUserProfileEvent extends UserProfileEvent {
  const GetUserProfileEvent(this.userId);
  final String userId;
}
