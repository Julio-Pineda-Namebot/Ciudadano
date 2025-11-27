import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";

class DisconnectGeolocalizationSocketUseCase {
  final GeolocalizationRepository repository;

  DisconnectGeolocalizationSocketUseCase(this.repository);

  void call() {
    repository.disconnectGeolocalizationSocket();
  }
}
