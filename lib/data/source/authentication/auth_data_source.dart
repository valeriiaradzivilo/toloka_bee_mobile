import '../../models/user_auth_model.dart';

abstract class AuthDataSource {
  Future<UserAuthModel> login(final String username, final String password);

  Future<void> logout();

  Future<void> register(final UserAuthModel user);

  Future<String> getAccessToken();

  Future<UserAuthModel> getCurrentUserData();
}
