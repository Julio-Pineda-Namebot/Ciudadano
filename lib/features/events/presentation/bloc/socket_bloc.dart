import "package:ciudadano/features/events/domain/usecases/connect_to_socket_use_case.dart";
import "package:ciudadano/features/events/domain/usecases/disconnect_incidents_reported_use_case.dart";
import "package:ciudadano/features/events/domain/usecases/disconnect_to_socket_use_case.dart";
import "package:ciudadano/features/events/domain/usecases/listen_incidents_reported_use_case.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/service_locator.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "socket_event.dart";
part "socket_state.dart";

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final ConnectToSocketUseCase _connectToSocketUseCase;
  final DisconnectFromSocketUseCase _disconnectFromSocketUseCase;
  final ListenIncidentsReportedUseCase _listenIncidentsReportedUseCase;
  final DisconnectIncidentsReportedUseCase _disconnectIncidentsReportedUseCase;

  SocketBloc(
    this._connectToSocketUseCase,
    this._disconnectFromSocketUseCase,
    this._listenIncidentsReportedUseCase,
    this._disconnectIncidentsReportedUseCase,
  ) : super(SocketInitial()) {
    on<ConnectToSocketEvent>(_onConnectToSocket);
    on<DisconnectFromSocketEvent>(_onDisconnectFromSocket);
    on<ListenIncidentsReportedEvent>(_onListenIncidentsReported);
    on<DisconnectIncidentsReportedEvent>(_onDisconnectIncidentsReported);
  }

  Future<void> _onConnectToSocket(
    ConnectToSocketEvent event,
    Emitter<SocketState> emit,
  ) async {
    final location = sl<LocationCubit>().state.location;
    if (location == null) {
      emit(const SocketErrorState("No se pudo obtener la ubicación actual"));
      return;
    }

    await _connectToSocketUseCase(location);
    emit(SocketConnectedState());
  }

  Future<void> _onDisconnectFromSocket(
    DisconnectFromSocketEvent event,
    Emitter<SocketState> emit,
  ) async {
    await _disconnectFromSocketUseCase({});
    emit(SocketDisconnectedState());
  }

  Future<void> _onListenIncidentsReported(
    ListenIncidentsReportedEvent event,
    Emitter<SocketState> emit,
  ) async {
    await _listenIncidentsReportedUseCase(
      (incident) => event.onIncidentReported(incident),
    );
  }

  Future<void> _onDisconnectIncidentsReported(
    DisconnectIncidentsReportedEvent event,
    Emitter<SocketState> emit,
  ) async {
    await _disconnectIncidentsReportedUseCase({});
  }
}
