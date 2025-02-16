import 'package:simple_logger/simple_logger.dart';

import '../models/location_model.dart';
import '../models/user_model.dart';

abstract class GeoDataSource {
  Future<void> updateLocation(LocationModel location);

  Future<bool> login(String username, String password);

  Future<void> logout();

  Future<void> register(UserModel user);

  static final logger = SimpleLogger();
}
