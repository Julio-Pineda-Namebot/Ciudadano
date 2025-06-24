import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/geolocalization/data/repository/location_repository_impl.dart";
import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";

final sl = GetIt.instance;

void setUpServiceLocator() {
  //Repositories
  sl.registerSingleton<LocationRepository>(LocationRepositoryImpl());

  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<DioClient>(
    DioClient(() async {
      final token = await sl<FlutterSecureStorage>().read(key: "auth_token");
      return token;
    }),
  );

  sl.registerLazySingleton(() => LocationCubit(sl<LocationRepository>()));
}
