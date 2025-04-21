import 'package:dartz/dartz.dart';

import '../models/user_auth_model.dart';
import '../repository/authentication/auth_repository.dart';
import 'usecase.dart';

class UpdateUserUsecase extends UseCase<Either, UserAuthModel> {
  final AuthRepository _authRepo;

  UpdateUserUsecase(this._authRepo);

  @override
  Future<Either> call(final UserAuthModel params) async =>
      throw UnimplementedError();
}
