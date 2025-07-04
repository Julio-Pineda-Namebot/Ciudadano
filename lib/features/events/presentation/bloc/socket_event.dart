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

// Chats
class ListenChatGroupCreatedEvent extends SocketEvent {
  final Function(ChatGroup) onChatGroupCreated;

  ListenChatGroupCreatedEvent(this.onChatGroupCreated);
}

class DisconnectChatGroupCreatedEvent extends SocketEvent {}

class ListenChatGroupMessageSentEvent extends SocketEvent {
  final Function(ChatMessage) onChatGroupMessageSent;

  ListenChatGroupMessageSentEvent(this.onChatGroupMessageSent);
}

class DisconnectChatGroupMessageSentEvent extends SocketEvent {}
