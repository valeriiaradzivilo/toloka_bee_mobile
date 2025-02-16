import 'package:dartz/dartz.dart';

import '../repository/geo_repository.dart';

class LoginUserUsecase {
  final GeoRepository _geoRepository;

  LoginUserUsecase(this._geoRepository);

  Future<Either<Fail, bool>> call(String username, String password) async {
    return _geoRepository.login(username, password);
  }
}
