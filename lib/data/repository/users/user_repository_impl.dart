import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/user_auth_model.dart';
import '../../source/users/user_data_source.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;
  final logger = SimpleLogger();

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<Either<Fail, UserAuthModel>> getUserById(final String id) async {
    try {
      final user = await _userDataSource.getUserById(id);
      return Right(user);
    } catch (e) {
      logger.severe('❌ Error while getting user by id: ${e.toString()}');
      return Left(Fail('Failed to get user by id'));
    }
  }
}
