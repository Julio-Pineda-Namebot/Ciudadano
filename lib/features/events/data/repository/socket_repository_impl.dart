import "package:ciudadano/features/chats/data/model/chat_group_model.dart";
import "package:ciudadano/features/chats/data/model/chat_message_model.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/events/data/source/socket_source.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:ciudadano/features/incidents/data/models/incident_model.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:latlong2/latlong.dart";

class SocketRepositoryImpl implements SocketRepository {
  final SocketSource _socketSource;

  const SocketRepositoryImpl(this._socketSource);

  @override
  Future<void> connect(LatLng location) async {
    await _socketSource.connect(location);
  }

  @override
  void disconnect() {
    _socketSource.disconnect();
  }

  @override
  void listenIncidentsReported(Function(Incident incident) onIncidentReported) {
    _socketSource.subscribeChannel(
      "incident:reported",
      onData: (data) => onIncidentReported(IncidentModel.fromJson(data)),
    );
  }

  @override
  void disconnectIncidentsReported() {
    _socketSource.disconnectChannel("incident:reported");
  }

  @override
  void listenChatGroupCreated(
    Function(ChatGroup chatGroup) onChatGroupCreated,
  ) {
    _socketSource.subscribeChannel(
      "chat_group:created",
      onData: (data) {
        final chatGroup = ChatGroupModel.fromJson(data);
        onChatGroupCreated(chatGroup);
      },
    );
  }

  @override
  void disconnectChatGroupCreated() {
    _socketSource.disconnectChannel("chat_group:created");
  }

  @override
  void listenChatGroupMessageSent(
    Function(ChatMessage chatMessage) onChatGroupMessage,
  ) {
    _socketSource.subscribeChannel(
      "chat_group:message_sent",
      onData: (data) {
        final chatMessage = ChatMessageModel.fromJson(data);
        onChatGroupMessage(chatMessage);
      },
    );
  }

  @override
  void disconnectChatGroupMessageSent() {
    _socketSource.disconnectChannel("chat_group:message_sent");
  }
}
