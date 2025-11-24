import "package:ciudadano/features/geolocalization/data/sources/geolocator_source.dart";
import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/domain/repositories/geolocalization_repository.dart";
import "package:latlong2/latlong.dart";

class GeolocalizationRepositoryImpl implements GeolocalizationRepository {
  final GeolocatorSource permissionSource;

  const GeolocalizationRepositoryImpl(this.permissionSource);

  @override
  Future<LocationStatus> checkStatus() {
    return permissionSource.checkStatus();
  }

  @override
  Future<LocationStatus> requestPermission() {
    return permissionSource.requestPermission();
  }

  @override
  Stream<LatLng> watchCurrentLocation() {
    return permissionSource.watchCurrentLocation();
  }
}
