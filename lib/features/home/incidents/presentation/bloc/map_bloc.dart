import "dart:async";
import "package:ciudadano/features/home/incidents/usercases/get_current_location.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";
import "map_event.dart";
import "map_state.dart";
import "package:ciudadano/features/home/incidents/usercases/get_incidents.dart";

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocation getCurrentLocation;
  final GetNearbyIncidents getNearbyIncidents;

  MapBloc({required this.getCurrentLocation, required this.getNearbyIncidents})
    : super(MapInitial()) {
    on<LoadCurrentLocation>(_onLoadCurrentLocation);
    on<UpdateLocation>(_onUpdateLocation);
  }

  Future<void> _onLoadCurrentLocation(
    LoadCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());

    final locationResult = await getCurrentLocation();

    await locationResult.fold(
      (failure) async {
        emit(MapError(failure));
      },
      (location) async {
        final incidents = await getNearbyIncidents(location);
        emit(MapLoaded(location, incidents));

        // Escucha continua de ubicación usando emit.forEach
        await emit.forEach<LatLng>(
          getCurrentLocation.stream(),
          onData: (newLocation) {
            final currentState = state;
            if (currentState is MapLoaded) {
              return MapLoaded(newLocation, currentState.incidents);
            }
            return state;
          },
          onError: (_, __) => MapError("Error en el stream de ubicación"),
        );
      },
    );
  }

  void _onUpdateLocation(UpdateLocation event, Emitter<MapState> emit) {
    // Ya no es necesario si usamos emit.forEach
  }

  @override
  Future<void> close() async {
    // No necesitamos cancelar manualmente porque emit.forEach lo gestiona
    return super.close();
  }
}
