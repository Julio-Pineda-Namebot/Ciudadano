import "package:ciudadano/features/geolocalization/data/sources/geolocalization_ws_source.dart";
import "package:ciudadano/features/geolocalization/data/sources/geolocator_source.dart";
import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";
import "package:latlong2/latlong.dart";

class GeolocalizationRepositoryImpl implements GeolocalizationRepository {
  final GeolocatorSource _permissionSource;
  final GeolocalizationWsSource _wsSource;

  const GeolocalizationRepositoryImpl(this._permissionSource, this._wsSource);

  @override
  Future<LocationStatus> checkStatus() {
    return _permissionSource.checkStatus();
  }

  @override
  Future<LocationStatus> requestPermission() {
    return _permissionSource.requestPermission();
  }

  @override
  Stream<LatLng> watchCurrentLocation() {
    return _permissionSource.watchCurrentLocation();
  }

  @override
  void connectGeolocalizationSocket(LatLng location) {
    _wsSource.connect(location);
  }

  @override
  void disconnectGeolocalizationSocket() {
    _wsSource.disconnect();
  }
}
