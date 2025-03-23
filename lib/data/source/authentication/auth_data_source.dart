import 'package:simple_logger/simple_logger.dart';

import '../../models/user_auth_model.dart';

abstract class AuthDataSource {
  Future<bool> login(final String username, final String password);

  Future<void> logout();

  Future<void> register(final UserAuthModel user);

  static final logger = SimpleLogger();
}
