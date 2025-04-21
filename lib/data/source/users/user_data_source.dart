import '../../models/user_auth_model.dart';

abstract class UserDataSource {
  Future<UserAuthModel> getUserById(final String id);
}
