import "package:ciudadano/features/geolocalization/domain/exceptions/location_permission_denied_exception.dart";
import "package:ciudadano/features/geolocalization/domain/exceptions/location_service_unavailable_exception.dart";
import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class LocationRepositoryImpl implements LocationRepository {
  // final FlutterSecureStorage _secureStorage = sl<FlutterSecureStorage>();

  @override
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw LocationServiceUnavailableException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedException();
    }

    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   final lat = await _secureStorage.read(key: "last_lat");
    //   final lng = await _secureStorage.read(key: "last_lng");

    //   if (lat != null && lng != null) {
    //     return LatLng(double.parse(lat), double.parse(lng));
    //   } else {
    //     throw Exception("Permiso denegado y sin última ubicación guardada");
    //   }
    // }

    Position position = await Geolocator.getCurrentPosition();

    // await _secureStorage.write(
    //   key: "last_lat",
    //   value: position.latitude.toString(),
    // );
    // await _secureStorage.write(
    //   key: "last_lng",
    //   value: position.longitude.toString(),
    // );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  Stream<LatLng> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).map((position) => LatLng(position.latitude, position.longitude));
  }
}
