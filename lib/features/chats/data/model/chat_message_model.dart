import "package:ciudadano/features/chats/data/model/chat_contact_model.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.createdAt,
    required super.sender,
    required super.groupId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"],
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]),
      sender: ChatContactModel.fromJson(json["user"]),
      groupId: json["group_id"],
    );
  }
}
