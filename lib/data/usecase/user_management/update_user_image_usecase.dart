import 'package:dartz/dartz.dart';

import '../../repository/authentication/auth_repository.dart';
import '../usecase.dart';

class UpdateUserImageUsecase extends UseCase<Either, String> {
  final AuthRepository _authRepo;

  UpdateUserImageUsecase(this._authRepo);

  @override
  Future<Either> call(final String params) async =>
      await _authRepo.changeImage(params);
}
