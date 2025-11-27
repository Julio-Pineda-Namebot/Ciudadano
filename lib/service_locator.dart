import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/core/api/logger_interceptor.dart";
import "package:ciudadano/core/ws/socket_io_client.dart";
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
}
