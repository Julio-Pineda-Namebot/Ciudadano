import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/service_locator.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "socket_event.dart";
part "socket_state.dart";

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final SocketRepository _socketRepository;

  SocketBloc(this._socketRepository) : super(SocketInitial()) {
    on<ConnectToSocketEvent>(_onConnectToSocket);
    on<DisconnectFromSocketEvent>(_onDisconnectFromSocket);
    on<ListenIncidentsReportedEvent>(_onListenIncidentsReported);
    on<DisconnectIncidentsReportedEvent>(_onDisconnectIncidentsReported);
    on<ListenChatGroupCreatedEvent>(_onListenChatGroupCreated);
    on<DisconnectChatGroupCreatedEvent>(_onDisconnectChatGroupCreated);
    on<ListenChatGroupMessageSentEvent>(_onListenChatGroupMessageSent);
    on<DisconnectChatGroupMessageSentEvent>(_onDisconnectChatGroupMessageSent);
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

    await _socketRepository.connect(location);
    emit(SocketConnectedState());
  }

  void _onDisconnectFromSocket(
    DisconnectFromSocketEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.disconnect();
    emit(SocketDisconnectedState());
  }

  void _onListenIncidentsReported(
    ListenIncidentsReportedEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.listenIncidentsReported((incident) {
      event.onIncidentReported(incident);
    });
  }

  void _onDisconnectIncidentsReported(
    DisconnectIncidentsReportedEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.disconnectIncidentsReported();
  }

  void _onListenChatGroupCreated(
    ListenChatGroupCreatedEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.listenChatGroupCreated((chatGroup) {
      event.onChatGroupCreated(chatGroup);
    });
  }

  void _onDisconnectChatGroupCreated(
    DisconnectChatGroupCreatedEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.disconnectChatGroupCreated();
  }

  void _onListenChatGroupMessageSent(
    ListenChatGroupMessageSentEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.listenChatGroupMessageSent((chatMessage) {
      event.onChatGroupMessageSent(chatMessage);
    });
  }

  void _onDisconnectChatGroupMessageSent(
    DisconnectChatGroupMessageSentEvent event,
    Emitter<SocketState> emit,
  ) {
    _socketRepository.disconnectChatGroupMessageSent();
  }
}
