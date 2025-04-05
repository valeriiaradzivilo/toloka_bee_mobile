import 'package:dartz/dartz.dart';

import '../models/user_auth_model.dart';
import '../repository/authentication/auth_repository.dart';

class LoginUserUsecase {
  final AuthRepository _authRepository;

  LoginUserUsecase(this._authRepository);

  Future<Either<Fail, UserAuthModel>> call(
    final String username,
    final String password,
  ) async =>
      _authRepository.login(username, password);
}
