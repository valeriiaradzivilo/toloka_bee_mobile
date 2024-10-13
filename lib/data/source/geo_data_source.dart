import '../models/location_model.dart';

abstract class GeoDataSource {
  Future<void> updateLocation(LocationModel location);
}
