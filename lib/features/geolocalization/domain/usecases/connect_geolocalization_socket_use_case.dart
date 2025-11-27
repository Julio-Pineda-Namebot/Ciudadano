import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";
import "package:latlong2/latlong.dart";

class ConnectGeolocalizationSocketUseCase {
  final GeolocalizationRepository repository;

  ConnectGeolocalizationSocketUseCase(this.repository);

  void call(LatLng location) {
    repository.connectGeolocalizationSocket(location);
  }
}
