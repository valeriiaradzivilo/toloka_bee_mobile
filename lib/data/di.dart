import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'repository/authentication/auth_repository.dart';
import 'repository/authentication/auth_repository_impl.dart';
import 'repository/notifications/notification_repository.dart';
import 'repository/notifications/notification_repository_impl.dart';
import 'repository/users/user_repository.dart';
import 'repository/users/user_repository_impl.dart';
import 'service/fcm_service.dart';
import 'source/authentication/auth_data_source.dart';
import 'source/authentication/auth_data_source_impl.dart';
import 'source/geolocation/geo_data_source.dart';
import 'source/geolocation/geo_data_source_imp.dart';
import 'source/notifications/fcm_data_source.dart';
import 'source/users/user_data_source.dart';
import 'source/users/user_data_source_impl.dart';
import 'usecase/get_all_requests_usecase.dart';
import 'usecase/get_current_user_data_usecase.dart';
import 'usecase/get_notification_by_id_usecase.dart';
import 'usecase/get_user_by_id_usecase.dart';
import 'usecase/get_volunteers_by_location_usecase.dart';
import 'usecase/login_user_usecase.dart';
import 'usecase/logout_user_usecase.dart';
import 'usecase/register_user_usecase.dart';
import 'usecase/send_notification_usecase.dart';
import 'usecase/subscribe_to_topic_usecase.dart';

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
  serviceLocator
      .registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(dio));
}

Future<void> initRepository() async {
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(serviceLocator()),
  );
}

Future<void> initUseCases() async {
  serviceLocator.registerLazySingleton<GetVolunteersByLocationUsecase>(
    () => GetVolunteersByLocationUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LoginUserUsecase>(
    () => LoginUserUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetCurrentUserDataUsecase>(
    () => GetCurrentUserDataUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetUserByIdUsecase>(
    () => GetUserByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetNotificationByIdUsecase>(
    () => GetNotificationByIdUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<GetAllRequestsUsecase>(
    () => GetAllRequestsUsecase(serviceLocator()),
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
