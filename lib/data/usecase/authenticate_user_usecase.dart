import 'package:dartz/dartz.dart';

import '../repository/authentication/auth_repository.dart';

class LoginUserUsecase {
  final AuthRepository _authRepository;

  LoginUserUsecase(this._authRepository);

  Future<Either<Fail, bool>> call(
      final String username, final String password,) async {
    return _authRepository.login(username, password);
  }
}
