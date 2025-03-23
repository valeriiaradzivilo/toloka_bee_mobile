import '../../models/location_model.dart';
import '../../source/geolocation/geo_data_source.dart';
import 'geo_repository.dart';

class GeoRepositoryImp implements GeoRepository {
  final GeoDataSource geoDataSource;

  GeoRepositoryImp(this.geoDataSource);

  @override
  Future<void> updateLocation(final LocationModel location) async {
    return await geoDataSource.updateLocation(location);
  }
}
