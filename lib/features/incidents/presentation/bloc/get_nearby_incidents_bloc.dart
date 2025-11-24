import "dart:async";

import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents_use_case.dart";
import "package:ciudadano/features/incidents/domain/usecases/watch_nearby_incidents_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";

abstract class GetNearbyIncidentsState extends Equatable {}

class GetNearbyIncidentsLoadingState extends GetNearbyIncidentsState {
  @override
  List<Object?> get props => [];
}

class GetNearbyIncidentsLoadedState extends GetNearbyIncidentsState {
  final List<Incident> incidents;
  GetNearbyIncidentsLoadedState(this.incidents);

  @override
  List<Object?> get props => [incidents];
}

class GetNearbyIncidentsErrorState extends GetNearbyIncidentsState {
  final String message;
  GetNearbyIncidentsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetNearbyIncidentsBloc extends Cubit<GetNearbyIncidentsState> {
  final GetNearbyIncidentsUseCase _getNearbyIncidentsUseCase;
  final WatchNearbyIncidentsUseCase _watchNearbyIncidentsUseCase;

  StreamSubscription<List<Incident>>? _incidentsSubscription;

  GetNearbyIncidentsBloc(
    this._getNearbyIncidentsUseCase,
    this._watchNearbyIncidentsUseCase,
  ) : super(GetNearbyIncidentsLoadingState());

  void loadNearbyIncidents(LatLng location) {
    _incidentsSubscription ??= _watchNearbyIncidentsUseCase(location).listen(
      (incidents) {
        emit(GetNearbyIncidentsLoadedState(incidents));
      },
      onError: (error) {
        emit(GetNearbyIncidentsErrorState(error.toString()));
      },
    );
  }

  void refetchNearbyIncidents(LatLng location) async {
    emit(GetNearbyIncidentsLoadingState());
    _getNearbyIncidentsUseCase(location);
  }

  @override
  Future<void> close() {
    _incidentsSubscription?.cancel();
    return super.close();
  }
}
