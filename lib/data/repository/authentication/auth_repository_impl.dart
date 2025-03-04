import 'package:dartz/dartz.dart';

import '../../models/user_auth_model.dart';
import '../../source/authentication/auth_data_source.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<Either<Fail, bool>> login(String username, String password) async {
    try {
      return Right(await _authDataSource.login(username, password));
    } catch (e) {
      return Left(Fail('Failed to login'));
    }
  }

  @override
  Future<Either<Fail, void>> register(UserAuthModel user) async {
    try {
      return Right(await _authDataSource.register(user));
    } catch (e) {
      return Left(Fail('Failed to register'));
    }
  }
}
