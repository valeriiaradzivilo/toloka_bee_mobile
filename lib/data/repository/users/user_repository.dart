import 'package:dartz/dartz.dart';

import '../../models/user_auth_model.dart';

abstract class UserRepository {
  Future<Either<Fail, UserAuthModel>> getUserById(final String id);
}
