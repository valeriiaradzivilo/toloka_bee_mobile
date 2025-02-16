import 'package:dartz/dartz.dart';

import '../models/location_model.dart';
import '../source/geo_data_source.dart';
import 'geo_repository.dart';

class GeoRepositoryImp implements GeoRepository {
  final GeoDataSource geoDataSource;

  GeoRepositoryImp(this.geoDataSource);

  @override
  Future<void> updateLocation(LocationModel location) async {
    return await geoDataSource.updateLocation(location);
  }

  @override
  Future<Either<Fail, bool>> login(String username, String password) async {
    try {
      return Right(await geoDataSource.login(username, password));
    } catch (e) {
      return Left(Fail('Failed to login'));
    }
  }
}
