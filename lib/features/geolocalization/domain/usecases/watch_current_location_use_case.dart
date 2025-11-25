import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";
import "package:latlong2/latlong.dart";

class WatchCurrentLocationUseCase {
  final GeolocalizationRepository _repository;

  const WatchCurrentLocationUseCase(this._repository);

  Stream<LatLng> call() {
    return _repository.watchCurrentLocation();
  }
}
