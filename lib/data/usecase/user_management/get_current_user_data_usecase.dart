import 'package:dartz/dartz.dart';

import '../../models/user_auth_model.dart';
import '../../repository/authentication/auth_repository.dart';

class GetCurrentUserDataUsecase {
  final AuthRepository _authRepository;

  GetCurrentUserDataUsecase(this._authRepository);

  Future<Either<Fail, UserAuthModel>> call() async =>
      _authRepository.getCurrentUserData();
}
