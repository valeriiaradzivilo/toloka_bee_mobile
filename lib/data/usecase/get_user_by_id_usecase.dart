import 'package:dartz/dartz.dart';

import '../models/user_auth_model.dart';
import '../repository/users/user_repository.dart';
import 'usecase.dart';

class GetUserByIdUsecase extends UseCase<Either, String> {
  final UserRepository _userRepository;

  GetUserByIdUsecase(this._userRepository);

  @override
  Future<Either<Fail, UserAuthModel>> call(final String params) async =>
      _userRepository.getUserById(params);
}
