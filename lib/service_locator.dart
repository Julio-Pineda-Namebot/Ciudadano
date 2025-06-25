import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/geolocalization/data/repository/location_repository_impl.dart";
import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/data/repository/incident_repository_impl.dart";
import "package:ciudadano/features/incidents/data/source/incident_api_service.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";

final sl = GetIt.instance;

void setUpServiceLocator() {
  // Sources
  sl.registerSingleton<IncidentApiService>(IncidentApiService());

  //Repositories
  sl.registerSingleton<LocationRepository>(LocationRepositoryImpl());
  sl.registerSingleton<IncidentRepository>(
    IncidentRepositoryImpl(sl<IncidentApiService>()),
  );

  //Use Cases
  sl.registerSingleton(GetNearbyIncidents(sl<IncidentRepository>()));

  // Utils
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<DioClient>(
    DioClient(() async {
      final token = await sl<FlutterSecureStorage>().read(key: "auth_token");
      return token;
    }),
  );

  // Cubits and Blocs
  sl.registerLazySingleton(() => LocationCubit(sl<LocationRepository>()));
  sl.registerFactory(() => NearbyIncidentsBloc(sl<GetNearbyIncidents>()));
}
