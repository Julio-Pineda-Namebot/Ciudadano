import "dart:async";

import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/service_locator.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

part "nearby_incidents_event.dart";
part "nearby_incidents_state.dart";

class NearbyIncidentsBloc
    extends Bloc<NearbyIncidentsEvent, NearbyIncidentsState> {
  final GetNearbyIncidentsUseCase getNearbyIncidents;
  Timer? _periodicTimer;

  NearbyIncidentsBloc(this.getNearbyIncidents)
    : super(NearbyIncidentsInitial()) {
    on<LoadNearbyIncidents>(_onLoadIncidents);
    on<NearbyIncidentReportedEvent>(_onIncidentReported);
    on<RefreshNearbyIncidents>(_onRefreshIncidents);
  }

  @override
  Future<void> close() {
    _periodicTimer?.cancel();
    return super.close();
  }

  void _startPeriodicUpdates() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => add(RefreshNearbyIncidents()),
    );
  }

  void stopPeriodicUpdates() {
    _periodicTimer?.cancel();
  }

  Future<void> _onLoadIncidents(
    LoadNearbyIncidents event,
    Emitter<NearbyIncidentsState> emit,
  ) async {
    emit(NearbyIncidentsLoading());

    final actuaLocation = sl<LocationCubit>().state.location;

    if (actuaLocation == null) {
      emit(
        const NearbyIncidentsError("No se pudo obtener la ubicación actual"),
      );
      return;
    }

    final incidents = await getNearbyIncidents(actuaLocation);

    incidents.fold(
      (failure) {
        emit(NearbyIncidentsError(failure));
      },
      (incidents) {
        emit(NearbyIncidentsLoaded(actuaLocation, incidents));
        // Iniciar actualizaciones periódicas después de cargar exitosamente
        _startPeriodicUpdates();
      },
    );
  }

  Future<void> _onRefreshIncidents(
    RefreshNearbyIncidents event,
    Emitter<NearbyIncidentsState> emit,
  ) async {
    // Solo actualizar si ya hay datos cargados para evitar mostrar loading
    if (state is! NearbyIncidentsLoaded) return;

    final actuaLocation = sl<LocationCubit>().state.location;

    if (actuaLocation == null) {
      return;
    }

    final incidents = await getNearbyIncidents(actuaLocation);

    incidents.fold(
      (failure) {
        // En caso de error durante refresh, mantener el estado actual
        // sin mostrar error para no interrumpir la experiencia del usuario
      },
      (incidents) {
        emit(NearbyIncidentsLoaded(actuaLocation, incidents));
      },
    );
  }

  Future<void> _onIncidentReported(
    NearbyIncidentReportedEvent event,
    Emitter<NearbyIncidentsState> emit,
  ) async {
    if (state is NearbyIncidentsLoaded) {
      final currentState = state as NearbyIncidentsLoaded;
      final updatedIncidents = List<Incident>.from(currentState.incidents)
        ..add(event.incident);
      emit(NearbyIncidentsLoaded(currentState.location, updatedIncidents));
    }
  }
}
