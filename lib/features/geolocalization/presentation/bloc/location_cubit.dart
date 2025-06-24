import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

class LocationState {
  final LatLng? location;

  const LocationState(this.location);
}

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;
  Stream<LatLng>? _locationStream;

  LocationCubit(this._locationRepository) : super(const LocationState(null)) {
    _startListening();
  }

  void _startListening() {
    _locationStream = _locationRepository.getLocationStream();
    _locationStream!.listen((location) {
      emit(LocationState(location));
    });
  }

  Future<void> loadInitialLocation() async {
    final location = await _locationRepository.getCurrentLocation();
    emit(LocationState(location));
  }

  LatLng? get currentLocation => state.location;
}
