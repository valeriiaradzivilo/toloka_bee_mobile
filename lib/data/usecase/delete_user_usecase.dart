import 'package:dartz/dartz.dart';

import '../repository/authentication/auth_repository.dart';
import 'usecase.dart';

class DeleteUserUsecase extends UseCase<Either, String> {
  final AuthRepository _authRepo;

  DeleteUserUsecase(this._authRepo);

  @override
  Future<Either> call(final String userId) async =>
      _authRepo.deleteUser(userId);
}
