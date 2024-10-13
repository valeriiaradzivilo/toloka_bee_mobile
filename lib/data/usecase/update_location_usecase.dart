import '../models/location_model.dart';
import '../repository/geo_repository.dart';
import 'usecase.dart';

class UpdateLocationUsecase extends UseCase<void, LocationModel> {
  final GeoRepository geoRepository;

  UpdateLocationUsecase(this.geoRepository);

  @override
  Future<void> call(LocationModel params) async {
    return await geoRepository.updateLocation(params);
  }
}
