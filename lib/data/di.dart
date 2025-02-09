import 'package:get_it/get_it.dart';

import 'repository/geo_repository.dart';
import 'repository/geo_repository_imp.dart';
import 'source/geo_data_source.dart';
import 'source/geo_data_source_imp.dart';
import 'usecase/authenticate_user_usecase.dart';
import 'usecase/update_location_usecase.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> init() async {
  // Initialize data sources
  await initDatasources();

  // Initialize repository
  await initRepository();

  // Initialize use cases
  await initUseCases();
}

Future<void> initDatasources() async {
  serviceLocator.registerLazySingleton<GeoDataSource>(() => GeoDataSourceImp());
}

Future<void> initRepository() async {
  serviceLocator.registerLazySingleton<GeoRepository>(
      () => GeoRepositoryImp(serviceLocator()));
}

Future<void> initUseCases() async {
  serviceLocator.registerLazySingleton<UpdateLocationUsecase>(
      () => UpdateLocationUsecase(serviceLocator()));

  serviceLocator.registerLazySingleton<AuthenticateUserUsecase>(
      () => AuthenticateUserUsecase());
}
