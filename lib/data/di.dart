import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'repository/authentication/auth_repository.dart';
import 'repository/authentication/auth_repository_impl.dart';
import 'repository/geolocation/geo_repository.dart';
import 'repository/geolocation/geo_repository_imp.dart';
import 'repository/notifications/notification_repository.dart';
import 'repository/notifications/notification_repository_impl.dart';
import 'service/fcm_service.dart';
import 'source/authentication/auth_data_source.dart';
import 'source/authentication/auth_data_source_impl.dart';
import 'source/geolocation/geo_data_source.dart';
import 'source/geolocation/geo_data_source_imp.dart';
import 'source/notifications/fcm_data_source.dart';
import 'usecase/get_current_user_data_usecase.dart';
import 'usecase/login_user_usecase.dart';
import 'usecase/logout_user_usecase.dart';
import 'usecase/register_user_usecase.dart';
import 'usecase/send_notification_usecase.dart';
import 'usecase/subscribe_to_topic_usecase.dart';
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
  final String backendUrl = 'http://10.0.2.2:8080';
  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: backendUrl,
      sendTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
      connectTimeout: const Duration(seconds: 40),
    ),
  );

  serviceLocator
      .registerLazySingleton<GeoDataSource>(() => GeoDataSourceImp(dio));
  serviceLocator
      .registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(dio));
  serviceLocator.registerLazySingleton<FcmDataSource>(() => FcmDataSource(dio));
  serviceLocator.registerLazySingleton<FcmService>(() => FcmService());
}

Future<void> initRepository() async {
  serviceLocator.registerLazySingleton<GeoRepository>(
    () => GeoRepositoryImp(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(serviceLocator()),
  );
}

Future<void> initUseCases() async {
  serviceLocator.registerLazySingleton<UpdateLocationUsecase>(
    () => UpdateLocationUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LoginUserUsecase>(
    () => LoginUserUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetCurrentUserDataUsecase>(
    () => GetCurrentUserDataUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LogoutUserUsecase>(
    () => LogoutUserUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<RegisterUserUsecase>(
    () => RegisterUserUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<SubscribeToTopicUsecase>(
    () => SubscribeToTopicUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<SendNotificationUsecase>(
    () => SendNotificationUsecase(serviceLocator()),
  );
}
