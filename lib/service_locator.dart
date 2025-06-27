import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/events/data/repository/socket_repository_impl.dart";
import "package:ciudadano/features/events/data/source/socket_source.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:ciudadano/features/events/domain/usecases/connect_to_socket_use_case.dart";
import "package:ciudadano/features/events/domain/usecases/disconnect_incidents_reported_use_case.dart";
import "package:ciudadano/features/events/domain/usecases/disconnect_to_socket_use_case.dart";
import "package:ciudadano/features/events/domain/usecases/listen_incidents_reported_use_case.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/geolocalization/data/repository/location_repository_impl.dart";
import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/data/repository/incident_repository_impl.dart";
import "package:ciudadano/features/incidents/data/source/incident_api_service.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:ciudadano/features/incidents/domain/usecases/create_incident_use_case.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents.dart";
import "package:ciudadano/features/incidents/presentation/bloc/create_incident/create_incident_bloc.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";

final sl = GetIt.instance;

void setUpServiceLocator() {
  // Utils
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<DioClient>(
    DioClient(() async {
      final token = await sl<FlutterSecureStorage>().read(key: "auth_token");
      return token;
    }),
  );

  // Sources
  sl.registerSingleton<IncidentApiService>(IncidentApiService());
  sl.registerSingleton<SocketSource>(SocketSource());

  //Repositories
  sl.registerSingleton<LocationRepository>(LocationRepositoryImpl());
  sl.registerSingleton<IncidentRepository>(
    IncidentRepositoryImpl(sl<IncidentApiService>()),
  );
  sl.registerSingleton<SocketRepository>(
    SocketRepositoryImpl(sl<SocketSource>()),
  );

  // Use Cases
  sl.registerSingleton(GetNearbyIncidentsUseCase(sl<IncidentRepository>()));
  sl.registerSingleton(CreateIncidentUseCase(sl<IncidentRepository>()));

  // Socket Use Cases
  sl.registerSingleton(ConnectToSocketUseCase(sl<SocketRepository>()));
  sl.registerSingleton(DisconnectFromSocketUseCase(sl<SocketRepository>()));
  sl.registerSingleton(ListenIncidentsReportedUseCase(sl<SocketRepository>()));
  sl.registerSingleton(
    DisconnectIncidentsReportedUseCase(sl<SocketRepository>()),
  );

  // Cubits and Blocs
  sl.registerLazySingleton(() => LocationCubit(sl<LocationRepository>()));
  sl.registerFactory(
    () => NearbyIncidentsBloc(sl<GetNearbyIncidentsUseCase>()),
  );
  sl.registerFactory(() => CreateIncidentBloc(sl<CreateIncidentUseCase>()));
  sl.registerFactory(
    () => SocketBloc(
      sl<ConnectToSocketUseCase>(),
      sl<DisconnectFromSocketUseCase>(),
      sl<ListenIncidentsReportedUseCase>(),
      sl<DisconnectIncidentsReportedUseCase>(),
    ),
  );
}
