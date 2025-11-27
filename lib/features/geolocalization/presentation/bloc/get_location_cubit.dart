import "dart:async";

import "package:ciudadano/features/geolocalization/domain/usecases/watch_current_location_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

class GetLocationState extends Equatable {
  final LatLng? location;

  const GetLocationState({this.location});

  @override
  List<Object?> get props => [location];
}

class GetLocationCubit extends Cubit<GetLocationState> {
  final WatchCurrentLocationUseCase _watchCurrentLocationUseCase;
  StreamSubscription<LatLng>? _locationSubscription;

  GetLocationCubit(this._watchCurrentLocationUseCase)
    : super(const GetLocationState());

  void listenLocation() {
    _locationSubscription ??= _watchCurrentLocationUseCase().listen(
      (location) {
        emit(GetLocationState(location: location));
      },
      onError: (_) {
        emit(const GetLocationState(location: null));
      },
    );
  }

  void stopListening() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
