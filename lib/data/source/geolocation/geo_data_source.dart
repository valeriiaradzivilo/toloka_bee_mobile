import 'package:simple_logger/simple_logger.dart';

import '../../models/location_model.dart';

abstract class GeoDataSource {
  Future<void> updateLocation(final LocationModel location);

  static final logger = SimpleLogger();
}
