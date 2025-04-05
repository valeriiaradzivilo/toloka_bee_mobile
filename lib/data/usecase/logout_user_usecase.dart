import 'package:dartz/dartz.dart';

import '../repository/authentication/auth_repository.dart';

class LogoutUserUsecase {
  final AuthRepository _authRepository;

  LogoutUserUsecase(this._authRepository);

  Future<Either<Fail, void>> call() async => _authRepository.logout();
}
