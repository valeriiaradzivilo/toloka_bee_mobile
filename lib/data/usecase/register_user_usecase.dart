import 'package:dartz/dartz.dart';

import '../models/user_model.dart';
import '../repository/geo_repository.dart';
import 'usecase.dart';

class RegisterUserUsecase extends UseCase<Either, UserModel> {
  final GeoRepository _geoRepository;

  RegisterUserUsecase(this._geoRepository);

  @override
  Future<Either> call(UserModel params) async {
    return await _geoRepository.register(params);
  }
}
