import 'dart:async';
import 'package:ciudadano/features/home/incidents/usercases/get_current_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';
import 'package:ciudadano/features/home/incidents/usercases/get_incidents.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocation getCurrentLocation;
  final GetIncidents getIncidents;

  Stream<LatLng>? _locationStream;
  StreamSubscription<LatLng>? _locationSubscription;

  MapBloc({
    required this.getCurrentLocation,
    required this.getIncidents,
  }) : super(MapInitial()) {
    on<LoadCurrentLocation>((event, emit) async {
      emit(MapLoading());

      final locationResult = await getCurrentLocation();
      final incidents = await getIncidents();

      locationResult.fold(
        (failure) => emit(MapError(failure)),
        (location) {
          emit(MapLoaded(location, incidents));

          _locationSubscription?.cancel();
          _locationStream = getCurrentLocation.stream();

          _locationSubscription = _locationStream!.listen((newLocation) {
            add(UpdateLocation(newLocation));
          });
        },
      );
    });

    on<UpdateLocation>((event, emit) {
      final currentState = state;
      if (currentState is MapLoaded) {
        emit(MapLoaded(event.location, currentState.incidents));
      }
    });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}

