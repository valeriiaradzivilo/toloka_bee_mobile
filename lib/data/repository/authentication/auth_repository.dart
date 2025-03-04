import 'package:dartz/dartz.dart';

import '../../models/user_auth_model.dart';

abstract class AuthRepository {
  Future<Either<Fail, bool>> login(String username, String password);
  Future<Either<Fail, void>> register(UserAuthModel user);
}
