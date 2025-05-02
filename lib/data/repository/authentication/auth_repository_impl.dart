import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../../features/profile/bloc/profile_state.dart';
import '../../models/user_auth_model.dart';
import '../../source/authentication/auth_data_source.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final logger = SimpleLogger();

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Either<Fail, UserAuthModel>> login(
    final String username,
    final String password,
  ) async {
    try {
      return Right(await _authDataSource.login(username, password));
    } catch (e) {
      return Left(Fail(e));
    }
  }

  @override
  Future<Either<Fail, String>> register(final UserAuthModel user) async {
    try {
      return Right(await _authDataSource.register(user));
    } catch (e) {
      return Left(Fail('Failed to register'));
    }
  }

  @override
  Future<Either<Fail, UserAuthModel>> getCurrentUserData() async {
    try {
      return Right(await _authDataSource.getCurrentUserData());
    } catch (e) {
      return Left(Fail('Failed to get current user data'));
    }
  }

  @override
  Future<Either<Fail, void>> logout() async {
    try {
      return Right(await _authDataSource.logout());
    } catch (e) {
      return Left(Fail('Failed to logout'));
    }
  }

  @override
  Future<Either<Fail, void>> updateUser(final ProfileUpdating user) async {
    try {
      return Right(await _authDataSource.updateUser(user));
    } catch (e) {
      logger.severe('Failed to update user: $e');
      return Left(Fail('Failed to update user'));
    }
  }

  @override
  Future<Either<Fail, void>> deleteUser(final String userId) async {
    try {
      return Right(await _authDataSource.deleteUser(userId));
    } catch (e) {
      return Left(Fail('Failed to delete user'));
    }
  }
}
