import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";
import "package:latlong2/latlong.dart";

class WatchCurrentLocationUseCase {
  final GeolocalizationRepository repository;

  const WatchCurrentLocationUseCase(this.repository);

  Stream<LatLng> call() {
    return repository.watchCurrentLocation();
  }
}
