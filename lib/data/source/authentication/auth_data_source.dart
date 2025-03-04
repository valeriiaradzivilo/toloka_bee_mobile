import 'package:simple_logger/simple_logger.dart';

import '../../models/user_auth_model.dart';

abstract class AuthDataSource {
  Future<bool> login(String username, String password);

  Future<void> logout();

  Future<void> register(UserAuthModel user);

  static final logger = SimpleLogger();
}
