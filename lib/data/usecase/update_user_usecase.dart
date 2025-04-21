import 'package:dartz/dartz.dart';

import '../../features/profile/bloc/profile_state.dart';
import '../repository/authentication/auth_repository.dart';
import 'usecase.dart';

class UpdateUserUsecase extends UseCase<Either, ProfileUpdating> {
  final AuthRepository _authRepo;

  UpdateUserUsecase(this._authRepo);

  @override
  Future<Either> call(final ProfileUpdating params) async =>
      _authRepo.updateUser(params);
}
