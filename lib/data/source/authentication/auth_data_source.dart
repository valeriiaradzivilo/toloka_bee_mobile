import '../../../features/profile/bloc/profile_state.dart';
import '../../models/user_auth_model.dart';

abstract class AuthDataSource {
  Future<UserAuthModel> login(final String username, final String password);

  Future<void> logout();

  Future<String> register(final UserAuthModel user);

  Future<String> getFirebaseMessagingAccessToken();

  Future<String> getUserIdToken();

  Future<UserAuthModel> getCurrentUserData();

  Future<void> updateUser(final ProfileUpdating user);

  Future<void> deleteUser(final String userId);
}
