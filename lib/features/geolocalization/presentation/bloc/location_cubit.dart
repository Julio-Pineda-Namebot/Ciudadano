import "dart:async";

import "package:ciudadano/features/geolocalization/domain/exceptions/location_permission_denied_exception.dart";
import "package:ciudadano/features/geolocalization/domain/exceptions/location_service_unavailable_exception.dart";
import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

abstract class LocationState {
  const LocationState();
}

class LocationLoadingState extends LocationState {
  const LocationLoadingState();
}

class LocationLoadedState extends LocationState {
  final LatLng location;

  const LocationLoadedState(this.location);
}

class LocationPermissionDeniedState extends LocationState {
  const LocationPermissionDeniedState();
}

class LocationErrorState extends LocationState {
  final String message;

  const LocationErrorState(this.message);
}

class LocationErrorServiceUnavailableState extends LocationErrorState {
  const LocationErrorServiceUnavailableState()
    : super("Servicio de ubicación no disponible");
}

class LocationErrorPermissionDeniedState extends LocationErrorState {
  const LocationErrorPermissionDeniedState()
    : super("Permiso de ubicación denegado");
}

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;
  StreamSubscription<LatLng>? locationSubscription;

  LocationCubit(this._locationRepository)
    : super(const LocationLoadingState()) {
    _loadInitialLocation().then((_) => _startListening());
  }

  void _startListening() {
    locationSubscription = _locationRepository.getLocationStream().listen((
      location,
    ) {
      if (!isClosed) {
        emit(LocationLoadedState(location));
      }
    });
  }

  Future<void> _loadInitialLocation() async {
    emit(const LocationLoadingState());
    try {
      final location = await _locationRepository.getCurrentLocation();
      emit(LocationLoadedState(location));
    } on LocationPermissionDeniedException {
      emit(const LocationErrorPermissionDeniedState());
    } on LocationServiceUnavailableException {
      emit(const LocationErrorServiceUnavailableState());
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    locationSubscription?.cancel();
    return super.close();
  }
}
