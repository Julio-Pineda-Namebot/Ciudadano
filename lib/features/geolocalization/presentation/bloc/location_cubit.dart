import "dart:async";

import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

class LocationState {
  final LatLng? location;
  final bool isLoading;

  const LocationState(this.location, {this.isLoading = false});
}

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;
  StreamSubscription<LatLng>? _locationSubscription;

  LocationCubit(this._locationRepository) : super(const LocationState(null)) {
    _startListening();
  }

  void _startListening() {
    _locationSubscription = _locationRepository.getLocationStream().listen((
      location,
    ) {
      if (!isClosed) {
        emit(LocationState(location));
      }
    });
  }

  Future<void> loadInitialLocation() async {
    emit(const LocationState(null, isLoading: true));
    final location = await _locationRepository.getCurrentLocation();
    emit(LocationState(location, isLoading: false));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  LatLng? get currentLocation => state.location;
}
