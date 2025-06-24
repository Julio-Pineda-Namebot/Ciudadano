import "package:ciudadano/features/home/incidents/repository/location_repository_impl.dart";
import "package:latlong2/latlong.dart";
import "package:dartz/dartz.dart";

class GetCurrentLocation {
  final LocationRepositoryImpl _repository = LocationRepositoryImpl();

  Future<Either<String, LatLng>> call() async {
    try {
      final location = await _repository.getCurrentLocation();
      return Right(location);
    } catch (e) {
      return const Left("No se pudo obtener la ubicación");
    }
  }

  Stream<LatLng> stream() {
    return _repository.getLocationStream();
  }
}
