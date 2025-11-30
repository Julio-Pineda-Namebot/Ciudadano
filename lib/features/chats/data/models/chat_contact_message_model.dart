import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/data/models/chat_contact_model.dart";

class ChatContactMessageModel extends ChatContactMessage {
  const ChatContactMessageModel({
    required super.id,
    required super.content,
    required super.sender,
    required super.createdAt,
  });

  factory ChatContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatContactMessageModel(
      id: json["id"],
      content: json["content"],
      sender: ChatContactModel(
        id: json["sender"]["id"],
        userId: json["sender"]["id"],
        firstName: json["sender"]["firstName"],
        lastName: json["sender"]["lastName"],
        phone: json["sender"]["phone"],
      ),
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
