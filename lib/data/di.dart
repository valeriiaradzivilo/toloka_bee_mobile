import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'repository/authentication/auth_repository.dart';
import 'repository/authentication/auth_repository_impl.dart';
import 'repository/complaints/complaint_repository.dart';
import 'repository/complaints/complaint_repository_impl.dart';
import 'repository/contacts/contacts_repository.dart';
import 'repository/contacts/contacts_repository_impl.dart';
import 'repository/notifications/notification_repository.dart';
import 'repository/notifications/notification_repository_impl.dart';
import 'repository/users/user_repository.dart';
import 'repository/users/user_repository_impl.dart';
import 'repository/volunteer_work/volunteer_work_repository.dart';
import 'repository/volunteer_work/volunteer_work_repository_impl.dart';
import 'service/fcm_service.dart';
import 'service/snackbar_service.dart';
import 'source/authentication/auth_data_source.dart';
import 'source/authentication/auth_data_source_impl.dart';
import 'source/complaints/complaint_data_source.dart';
import 'source/complaints/complaint_data_source_impl.dart';
import 'source/contacts/contacts_data_source.dart';
import 'source/contacts/contacts_data_source_impl.dart';
import 'source/geolocation/geo_data_source.dart';
import 'source/geolocation/geo_data_source_imp.dart';
import 'source/notifications/fcm_data_source.dart';
import 'source/notifications/fcm_data_source_impl.dart';
import 'source/users/user_data_source.dart';
import 'source/users/user_data_source_impl.dart';
import 'source/volunteer_work/volunteer_work_data_source.dart';
import 'source/volunteer_work/volunteer_work_data_source_impl.dart';
import 'usecase/complaints/get_request_complaints_grouped_usecase.dart';
import 'usecase/complaints/get_user_complaints_grouped_usecase.dart';
import 'usecase/complaints/report_request_usecase.dart';
import 'usecase/complaints/report_user_usecase.dart';
import 'usecase/contacts/delete_contacts_by_id_usecase.dart';
import 'usecase/contacts/get_contacts_by_user_id_usecase.dart';
import 'usecase/contacts/save_contacts_usecase.dart';
import 'usecase/contacts/update_contacts_usecase.dart';
import 'usecase/get_notification_by_id_usecase.dart';
import 'usecase/get_volunteers_by_location_usecase.dart';
import 'usecase/requests/accept_request_usecase.dart';
import 'usecase/requests/delete_request_usecase.dart';
import 'usecase/requests/get_all_requests_usecase.dart';
import 'usecase/requests/get_requests_by_ids_usecase.dart';
import 'usecase/requests/get_requests_by_user_id_usecase.dart';
import 'usecase/send_notification_usecase.dart';
import 'usecase/subscribe_to_topic_usecase.dart';
import 'usecase/user_management/delete_user_usecase.dart';
import 'usecase/user_management/get_current_user_data_usecase.dart';
import 'usecase/user_management/get_user_by_id_usecase.dart';
import 'usecase/user_management/login_user_usecase.dart';
import 'usecase/user_management/logout_user_usecase.dart';
import 'usecase/user_management/register_user_usecase.dart';
import 'usecase/user_management/update_user_usecase.dart';
import 'usecase/volunteer_work/confirm_volunteer_work_by_requester_usecase.dart';
import 'usecase/volunteer_work/confirm_volunteer_work_by_volunteer_usecase.dart';
import 'usecase/volunteer_work/get_volunteer_work_by_request_id_usecase.dart';
import 'usecase/volunteer_work/get_volunteer_work_by_user_id.dart';
import 'usecase/volunteer_work/start_volunteer_work_usecase.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> init() async {
  await initDatasources();
  await initRepository();
  await initUseCases();
}

Future<void> initDatasources() async {
  final backendUrl = 'http://10.0.2.2:8080';
  final dio = Dio(
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
  serviceLocator
      .registerLazySingleton<FcmDataSource>(() => FcmDataSourceImpl(dio));
  serviceLocator
      .registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(dio));
  serviceLocator.registerLazySingleton<ContactsDataSource>(
    () => ContactsDataSourceImpl(dio),
  );
  serviceLocator.registerLazySingleton<ComplaintDataSource>(
    () => ComplaintDataSourceImpl(dio),
  );
  serviceLocator.registerLazySingleton<VolunteerWorkDataSource>(
    () => VolunteerWorkDataSourceImpl(dio),
  );

  serviceLocator.registerSingleton<SnackbarService>(SnackbarService());
  serviceLocator.registerLazySingleton<FcmService>(() => FcmService());
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
  serviceLocator.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ComplaintRepository>(
    () => ComplaintRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<VolunteerWorkRepository>(
    () => VolunteerWorkRepositoryImpl(serviceLocator(), serviceLocator()),
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
  serviceLocator.registerLazySingleton<UpdateUserUsecase>(
    () => UpdateUserUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetRequestsByUserIdUsecase>(
    () => GetRequestsByUserIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<DeleteUserUsecase>(
    () => DeleteUserUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<DeleteRequestUsecase>(
    () => DeleteRequestUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AcceptRequestUsecase>(
    () => AcceptRequestUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SendNotificationUsecase>(
    () => SendNotificationUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SaveContactUsecase>(
    () => SaveContactUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<UpdateContactUsecase>(
    () => UpdateContactUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetContactByUserIdUsecase>(
    () => GetContactByUserIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<DeleteContactByIdUsecase>(
    () => DeleteContactByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetRequestComplaintsGroupedUsecase>(
    () => GetRequestComplaintsGroupedUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetUserComplaintsGroupedUsecase>(
    () => GetUserComplaintsGroupedUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ReportUserUsecase>(
    () => ReportUserUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ReportRequestUsecase>(
    () => ReportRequestUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<StartVolunteerWorkUsecase>(
    () => StartVolunteerWorkUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ConfirmVolunteerWorkByVolunteerUsecase>(
    () => ConfirmVolunteerWorkByVolunteerUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ConfirmVolunteerWorkByRequesterUsecase>(
    () => ConfirmVolunteerWorkByRequesterUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetVolunteerWorksByUserIdUsecase>(
    () => GetVolunteerWorksByUserIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetVolunteerWorkByRequestIdUsecase>(
    () => GetVolunteerWorkByRequestIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetRequestsByIdsUsecase>(
    () => GetRequestsByIdsUsecase(serviceLocator()),
  );
}
