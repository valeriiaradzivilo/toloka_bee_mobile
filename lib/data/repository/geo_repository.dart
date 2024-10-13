import '../models/location_model.dart';

abstract class GeoRepository {
  Future<void> updateLocation(LocationModel location);
}
