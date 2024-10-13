import '../models/location_model.dart';
import 'geo_repository.dart';
import '../source/geo_data_source.dart';

class GeoRepositoryImp implements GeoRepository {
  final GeoDataSource geoDataSource;

  GeoRepositoryImp(this.geoDataSource);

  @override
  Future<void> updateLocation(LocationModel location) async {
    return await geoDataSource.updateLocation(location);
  }
}
