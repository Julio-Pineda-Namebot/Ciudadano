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
    extends Bloc<NearbyIncidentsMapEvent, NearbyIncidentsState> {
  final GetNearbyIncidents getNearbyIncidents;

  NearbyIncidentsBloc(this.getNearbyIncidents)
    : super(NearbyIncidentsInitial()) {
    on<LoadNearbyIncidents>(_onLoadIncidents);
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
      },
    );
  }
}
