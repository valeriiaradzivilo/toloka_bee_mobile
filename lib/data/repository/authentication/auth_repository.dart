import 'package:dartz/dartz.dart';

import '../../models/user_auth_model.dart';

abstract class AuthRepository {
  Future<Either<Fail, UserAuthModel>> login(
    final String username,
    final String password,
  );
  Future<Either<Fail, void>> register(final UserAuthModel user);
  Future<Either<Fail, UserAuthModel>> getCurrentUserData();
  Future<Either<Fail, void>> logout();
}
