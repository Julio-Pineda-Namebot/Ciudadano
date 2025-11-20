import "dart:async";

import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents.dart";
import "package:ciudadano/features/incidents/domain/usecases/watch_nearby_incidents_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

part "nearby_incidents_event.dart";
part "nearby_incidents_state.dart";

class NearbyIncidentsBloc
    extends Bloc<NearbyIncidentsEvent, NearbyIncidentsState> {
  final GetNearbyIncidentsUseCase getNearbyIncidents;
  final WatchNearbyIncidentsUseCase watchNearbyIncidents;

  StreamSubscription? _sub;

  NearbyIncidentsBloc(this.getNearbyIncidents, this.watchNearbyIncidents)
    : super(NearbyIncidentsInitial()) {
    on<LoadNearbyIncidents>(_onLoadIncidents);
    on<_StreamUpdateNearbyIncidents>(_onStreamUpdateNearbyIncidents);
  }

  Future<void> _onLoadIncidents(
    LoadNearbyIncidents event,
    Emitter<NearbyIncidentsState> emit,
  ) async {
    emit(NearbyIncidentsLoading());

    final actuaLocation = event.userLocation;

    final incidents = await getNearbyIncidents(actuaLocation);

    incidents.fold(
      (failure) {
        emit(NearbyIncidentsError(failure));
      },
      (incidents) async {
        emit(NearbyIncidentsLoaded(actuaLocation, incidents));
        final nearbyIncidentsStream = await watchNearbyIncidents({});
        _sub ??= nearbyIncidentsStream.listen((incidents) {
          add(_StreamUpdateNearbyIncidents(incidents, actuaLocation));
        });
      },
    );
  }

  void _onStreamUpdateNearbyIncidents(
    _StreamUpdateNearbyIncidents event,
    Emitter<NearbyIncidentsState> emit,
  ) {
    emit(NearbyIncidentsLoaded(event.userLocation, event.incidents));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
