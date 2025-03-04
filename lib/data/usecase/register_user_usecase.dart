import 'package:dartz/dartz.dart';

import '../models/user_auth_model.dart';
import '../repository/authentication/auth_repository.dart';
import 'usecase.dart';

class RegisterUserUsecase extends UseCase<Either, UserAuthModel> {
  final AuthRepository _authRepo;

  RegisterUserUsecase(this._authRepo);

  @override
  Future<Either> call(UserAuthModel params) async {
    return await _authRepo.register(params);
  }
}
