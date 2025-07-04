import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";

abstract class ChatMessage {
  final String id;
  final String content;
  final DateTime createdAt;
  final ChatContact sender;
  final String groupId;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.sender,
    required this.groupId,
  });
}
