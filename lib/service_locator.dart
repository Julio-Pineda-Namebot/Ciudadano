import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/core/api/logger_interceptor.dart";
import "package:ciudadano/core/ws/socket_io_client.dart";
import "package:ciudadano/features/alerts/data/repository/alert_repository_impl.dart";
import "package:ciudadano/features/alerts/data/source/alert_remote_data_source.dart";
import "package:ciudadano/features/alerts/domain/repository/alert_repository.dart";
import "package:ciudadano/features/alerts/domain/usecases/create_alert_use_case.dart";
import "package:ciudadano/features/alerts/presentation/bloc/alert_bloc.dart";
import "package:ciudadano/features/app_shell/presentation/bloc/presentation_cubit.dart";
import "package:ciudadano/features/auth/data/interceptors/auth_interceptor.dart";
import "package:ciudadano/features/auth/data/repositories/auth_repository_impl.dart";
import "package:ciudadano/features/auth/data/sources/auth_api_source.dart";
import "package:ciudadano/features/auth/data/sources/auth_secure_storage_source.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_get_profile_if_authenticated.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_login_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_logout_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_register_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_resend_verification_email_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_reset_password_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_send_reset_password_email_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_verify_email_use_case.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:ciudadano/features/chats/data/repositories/chat_repository_impl.dart";
import "package:ciudadano/features/chats/data/source/chat_api_source.dart";
import "package:ciudadano/features/chats/data/source/chat_in_memory_stream_source.dart";
import "package:ciudadano/features/chats/data/source/chat_local_permission_source.dart";
import "package:ciudadano/features/chats/data/source/chat_ws_source.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:ciudadano/features/chats/presentation/bloc/add_chat_contact_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/check_contacts_permission_status_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/create_chat_group_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_contact_messages_cursor_paginated_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_contacts_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_group_messages_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_groups_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_possible_contacts_by_phone_cubit.dart";
import "package:ciudadano/features/comunity/data/datasource/activity_local_datasource.dart";
import "package:ciudadano/features/comunity/data/datasource/cam_feed_local_datasource.dart";
import "package:ciudadano/features/comunity/data/datasource/event_local_datasource.dart";
import "package:ciudadano/features/comunity/data/repository/activity_repository_impl.dart";
import "package:ciudadano/features/comunity/data/repository/cam_feed_repository_impl.dart";
import "package:ciudadano/features/comunity/data/repository/event_repository_impl.dart";
import "package:ciudadano/features/comunity/domain/repository/activity_repository.dart";
import "package:ciudadano/features/comunity/domain/repository/cam_feed_repository.dart";
import "package:ciudadano/features/comunity/domain/repository/event_repository.dart";
import "package:ciudadano/features/comunity/domain/usecases/activity/add_activity.dart";
import "package:ciudadano/features/comunity/domain/usecases/activity/get_activity.dart";
import "package:ciudadano/features/comunity/domain/usecases/event/add_event.dart";
import "package:ciudadano/features/comunity/domain/usecases/event/get_event.dart";
import "package:ciudadano/features/comunity/domain/usecases/event/toggle_join_event.dart";
import "package:ciudadano/features/comunity/domain/usecases/surveillance/get_cam_feeds.dart";
import "package:ciudadano/features/comunity/presentation/bloc/activity/activity_bloc.dart";
import "package:ciudadano/features/comunity/presentation/bloc/event/event_bloc.dart";
import "package:ciudadano/features/comunity/presentation/bloc/surveillance/cam_bloc.dart";
import "package:ciudadano/features/geolocalization/data/repositories/geolocalization_repository_impl.dart";
import "package:ciudadano/features/geolocalization/data/sources/geolocalization_ws_source.dart";
import "package:ciudadano/features/geolocalization/data/sources/geolocator_source.dart";
import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/check_geolocalization_permission_status_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/connect_geolocalization_socket_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/disconnect_geolocalization_socket_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/request_geolocalization_permission_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/watch_current_location_use_case.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:ciudadano/features/incidents/data/repositories/incident_repository_impl.dart";
import "package:ciudadano/features/incidents/data/sources/incident_api_source.dart";
import "package:ciudadano/features/incidents/data/sources/incident_in_memory_stream_source.dart";
import "package:ciudadano/features/incidents/domain/repositories/incident_repository.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents_use_case.dart";
import "package:ciudadano/features/incidents/domain/usecases/report_incident_use_case.dart";
import "package:ciudadano/features/incidents/domain/usecases/watch_incident_reported_use_case.dart";
import "package:ciudadano/features/incidents/domain/usecases/watch_nearby_incidents_use_case.dart";
import "package:ciudadano/features/incidents/presentation/bloc/get_nearby_incidents_cubit.dart";
import "package:ciudadano/features/incidents/presentation/bloc/report_incident_cubit.dart";
import "package:ciudadano/features/notifications/data/repository/notification_repository_impl.dart";
import "package:ciudadano/features/notifications/data/source/notification_api_source.dart";
import "package:ciudadano/features/notifications/data/source/notification_local_source.dart";
import "package:ciudadano/features/notifications/domain/repository/notification_repository.dart";
import "package:ciudadano/features/notifications/domain/usecases/initialize_notifications_use_case.dart";
import "package:ciudadano/features/notifications/domain/usecases/listen_to_notifications_use_case.dart";
import "package:ciudadano/features/notifications/domain/usecases/register_push_token_use_case.dart";
import "package:ciudadano/features/notifications/domain/usecases/request_notification_permissions_use_case.dart";
import "package:ciudadano/features/notifications/presentation/bloc/notification_bloc.dart";
import "package:get_it/get_it.dart";
import "package:logger/logger.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

final sl = GetIt.instance;

Future<void> setUpServiceLocator() async {
  // Global
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton(const FlutterSecureStorage());
  sl.registerSingleton(
    Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
    ),
  );
  sl.registerSingleton(LoggerInterceptor(sl()));
  sl.registerSingleton(AuthInterceptor());
  sl.registerSingleton(DioClient());
  sl.registerFactory(() => SocketIoClient());

  // Repositories
  //// Auth
  sl.registerSingleton(AuthApiSource(sl()));
  sl.registerSingleton(AuthSecureStorageSource(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  //// Geolocalization
  sl.registerSingleton(GeolocatorSource());
  sl.registerSingleton(GeolocalizationWsSource(sl()));
  sl.registerSingleton<GeolocalizationRepository>(
    GeolocalizationRepositoryImpl(sl(), sl()),
  );
  //// Incidents
  sl.registerSingleton(IncidentApiSource(sl()));
  sl.registerSingleton(IncidentInMemoryStreamSource());
  sl.registerSingleton<IncidentRepository>(
    IncidentRepositoryImpl(sl(), sl(), sl()),
  );
  //// Chats
  sl.registerSingleton(ChatApiSource(sl()));
  sl.registerSingleton(ChatInMemoryStreamSource());
  sl.registerSingleton(ChatWsSource(sl()));
  sl.registerSingleton(ChatLocalPermissionSource());
  sl.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(sl(), sl(), sl(), sl()),
  );
  //// Alerts
  sl.registerSingleton<AlertRemoteDataSource>(AlertRemoteDataSourceImpl());
  sl.registerSingleton<AlertRepository>(
    AlertRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerSingleton(CreateAlertUseCase(sl<AlertRepository>()));
  //// Notifications
  sl.registerSingleton<NotificationLocalSource>(NotificationLocalSourceImpl());
  sl.registerSingleton<NotificationApiSource>(NotificationApiSourceImpl());
  sl.registerSingleton<NotificationRepository>(
    NotificationRepositoryImpl(
      localSource: sl<NotificationLocalSource>(),
      apiSource: sl<NotificationApiSource>(),
    ),
  );

  // Use Cases
  //// Auth
  sl.registerSingleton(AuthRegisterUseCase(sl()));
  sl.registerSingleton(AuthLoginUseCase(sl()));
  sl.registerSingleton(AuthResetPasswordUseCase(sl()));
  sl.registerSingleton(AuthSendResetPasswordEmailUseCase(sl()));
  sl.registerSingleton(AuthResendVerificationEmailUseCase(sl()));
  sl.registerSingleton(AuthVerifyEmailUseCase(sl()));
  sl.registerSingleton(AuthGetProfileIfAuthenticated(sl()));
  sl.registerSingleton(AuthLogoutUseCase(sl()));
  //// Geolocalization
  sl.registerSingleton(RequestGeolocalizationPermissionUseCase(sl()));
  sl.registerSingleton(CheckGeolocalizationPermissionStatusUseCase(sl()));
  sl.registerSingleton(WatchCurrentLocationUseCase(sl()));
  sl.registerSingleton(ConnectGeolocalizationSocketUseCase(sl()));
  sl.registerSingleton(DisconnectGeolocalizationSocketUseCase(sl()));
  //// Incidents
  sl.registerSingleton(GetNearbyIncidentsUseCase(sl()));
  sl.registerSingleton(WatchNearbyIncidentsUseCase(sl()));
  sl.registerSingleton(WatchIncidentReportedUseCase(sl()));
  sl.registerSingleton(ReportIncidentUseCase(sl()));
  //// Notifications
  sl.registerSingleton(
    InitializeNotificationsUseCase(sl<NotificationRepository>()),
  );
  sl.registerSingleton(RegisterPushTokenUseCase(sl<NotificationRepository>()));
  sl.registerSingleton(
    RequestNotificationPermissionsUseCase(sl<NotificationRepository>()),
  );
  sl.registerSingleton(
    ListenToNotificationsUseCase(sl<NotificationRepository>()),
  );

  // Blocs / Cubits
  sl.registerFactory(() => PresentationCubit());
  //// Auth
  sl.registerFactory(() => AuthCubit(sl(), sl()));
  //// Geolocalization
  sl.registerFactory(() => GeolocalizationPermissionCubit(sl(), sl()));
  sl.registerFactory(() => GetLocationCubit(sl()));
  //// Incidents
  sl.registerFactory(() => GetNearbyIncidentsCubit(sl(), sl()));
  sl.registerFactory(() => ReportIncidentCubit(sl()));
  //// Chats
  sl.registerFactory(() => GetChatContactsCubit(sl()));
  sl.registerFactory(() => GetPossibleContactsByPhoneCubit(sl()));
  sl.registerFactory(() => CheckContactsPermissionStatusCubit(sl()));
  sl.registerFactory(() => AddChatContactCubit(sl()));
  sl.registerFactory(() => GetChatContactMessagesCursorPaginatedCubit(sl()));
  sl.registerFactory(() => GetChatGroupMessagesCubit(sl()));
  sl.registerFactory(() => GetChatGroupsCubit(sl()));
  sl.registerFactory(() => CreateChatGroupCubit(sl()));
  //// Alerts
  sl.registerFactory(() => AlertBloc(createAlertUseCase: sl()));
  //// Notifications

  sl.registerLazySingleton(
    () => NotificationBloc(
      initializeNotificationsUseCase: sl<InitializeNotificationsUseCase>(),
      registerPushTokenUseCase: sl<RegisterPushTokenUseCase>(),
      requestNotificationPermissionsUseCase:
          sl<RequestNotificationPermissionsUseCase>(),
      listenToNotificationsUseCase: sl<ListenToNotificationsUseCase>(),
      notificationRepository: sl<NotificationRepository>(),
    ),
  );

  // Activity - Comunity
  sl.registerLazySingleton<ActividadLocalDatasource>(
    () => ActividadLocalDatasourceImpl(),
  );

  sl.registerLazySingleton<ActividadRepository>(
    () => ActividadRepositoryImpl(datasource: sl()),
  );

  sl.registerLazySingleton<GetActividades>(() => GetActividades(sl()));
  sl.registerLazySingleton<AddActividad>(() => AddActividad(sl()));

  sl.registerFactory<ActividadBloc>(
    () => ActividadBloc(getActividades: sl(), addActividad: sl()),
  );

  // Event - Comunity
  sl.registerLazySingleton<EventoLocalDatasource>(
    () => EventoLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<EventoRepository>(
    () => EventoRepositoryImpl(datasource: sl()),
  );
  sl.registerLazySingleton<GetEventos>(() => GetEventos(sl()));
  sl.registerLazySingleton<AddEvento>(() => AddEvento(sl()));
  sl.registerLazySingleton<ToggleJoinEvento>(() => ToggleJoinEvento(sl()));
  sl.registerFactory<EventoBloc>(
    () => EventoBloc(getEventos: sl(), addEvento: sl(), toggleJoin: sl()),
  );

  // surveillance - Comunity
  sl.registerLazySingleton<CamFeedLocalDatasource>(
    () => CamFeedLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<CamFeedRepository>(
    () => CamFeedRepositoryImpl(datasource: sl()),
  );
  sl.registerLazySingleton<GetCamFeeds>(() => GetCamFeeds(sl()));
  sl.registerFactory<CamBloc>(() => CamBloc(getFeeds: sl()));

  // // safe-route - Sidebar
  // sl.registerFactory(() => RouteBloc(GetRouteUseCase(sl())));
  // sl.registerLazySingleton(() => GetRouteUseCase(sl()));
  // sl.registerLazySingleton<RouteRepository>(() => RouteRepositoryImpl(sl()));
  // sl.registerLazySingleton(() => RouteRemoteDatasource());
}
