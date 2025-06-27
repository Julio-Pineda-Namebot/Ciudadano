part of "socket_bloc.dart";

abstract class SocketEvent {}

class ConnectToSocketEvent extends SocketEvent {}

class DisconnectFromSocketEvent extends SocketEvent {}

class SocketErrorEvent extends SocketEvent {
  final String message;

  SocketErrorEvent(this.message);
}

// Incidents
class ListenIncidentsReportedEvent extends SocketEvent {
  final Function(Incident) onIncidentReported;

  ListenIncidentsReportedEvent(this.onIncidentReported);
}

class DisconnectIncidentsReportedEvent extends SocketEvent {}
