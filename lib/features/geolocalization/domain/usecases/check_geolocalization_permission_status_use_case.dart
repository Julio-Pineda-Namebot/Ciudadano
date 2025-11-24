import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";

class CheckGeolocalizationPermissionStatusUseCase {
  final GeolocalizationRepository repository;

  CheckGeolocalizationPermissionStatusUseCase(this.repository);

  Future<LocationStatus> call() async {
    return await repository.checkStatus();
  }
}
