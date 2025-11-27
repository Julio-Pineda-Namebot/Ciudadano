import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:latlong2/latlong.dart";

abstract class GeolocalizationRepository {
  Future<LocationStatus> checkStatus();
  Future<LocationStatus> requestPermission();
  Stream<LatLng> watchCurrentLocation();
  void connectGeolocalizationSocket(LatLng location);
  void disconnectGeolocalizationSocket();
}
