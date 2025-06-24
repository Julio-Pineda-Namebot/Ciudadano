import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class LocationRepositoryImpl {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Servicios de ubicación deshabilitados");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final lat = await _secureStorage.read(key: "last_lat");
      final lng = await _secureStorage.read(key: "last_lng");

      if (lat != null && lng != null) {
        return LatLng(double.parse(lat), double.parse(lng));
      } else {
        throw Exception("Permiso denegado y sin última ubicación guardada");
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    await _secureStorage.write(
      key: "last_lat",
      value: position.latitude.toString(),
    );
    await _secureStorage.write(
      key: "last_lng",
      value: position.longitude.toString(),
    );

    return LatLng(position.latitude, position.longitude);
  }

  Stream<LatLng> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((position) => LatLng(position.latitude, position.longitude));
  }
}
