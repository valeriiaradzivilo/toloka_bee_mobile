import 'package:dartz/dartz.dart';

import '../../../features/profile/bloc/profile_state.dart';
import '../../models/user_auth_model.dart';

abstract class AuthRepository {
  Future<Either<Fail, UserAuthModel>> login(
    final String username,
    final String password,
  );
  Future<Either<Fail, String>> register(final UserAuthModel user);
  Future<Either<Fail, UserAuthModel>> getCurrentUserData();
  Future<Either<Fail, void>> logout();
  Future<Either<Fail, void>> updateUser(final ProfileUpdating user);
  Future<Either<Fail, void>> deleteUser(final String userId);
}
