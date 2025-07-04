import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:latlong2/latlong.dart";

abstract class SocketRepository {
  Future<void> connect(LatLng location);
  void disconnect();

  // Incidents
  void listenIncidentsReported(Function(Incident incident) onIncidentReported);
  void disconnectIncidentsReported();

  // Chats
  void listenChatGroupCreated(Function(ChatGroup chatGroup) onChatGroupCreated);
  void disconnectChatGroupCreated();

  void listenChatGroupMessageSent(
    Function(ChatMessage chatMessage) onChatGroupMessage,
  );
  void disconnectChatGroupMessageSent();
}
