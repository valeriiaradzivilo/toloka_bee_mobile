import 'package:dartz/dartz.dart';

import '../models/location_model.dart';
import '../models/user_model.dart';

abstract class GeoRepository {
  Future<void> updateLocation(LocationModel location);

  Future<Either<Fail, bool>> login(String username, String password);

  Future<Either<Fail, void>> register(UserModel user);
}
