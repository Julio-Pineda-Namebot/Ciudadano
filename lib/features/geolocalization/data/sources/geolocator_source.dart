import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class GeolocatorSource {
  Future<LocationStatus> checkStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.gpsDisabled;
    }

    final permission = await Geolocator.checkPermission();

    return _mapPermission(permission);
  }

  Future<LocationStatus> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationStatus.gpsDisabled;
    }

    final permission = await Geolocator.requestPermission();

    return _mapPermission(permission);
  }

  Stream<LatLng> watchCurrentLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((position) => LatLng(position.latitude, position.longitude));
  }

  LocationStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationStatus.granted;
      case LocationPermission.denied:
        return LocationStatus.denied;
      case LocationPermission.deniedForever:
        return LocationStatus.permanentlyDenied;
      default:
        return LocationStatus.denied;
    }
  }
}
