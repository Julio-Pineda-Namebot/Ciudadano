import "package:ciudadano/features/chats/data/models/chat_group_model.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";

class ChatGroupMessageModel extends ChatGroupMessage {
  const ChatGroupMessageModel({
    required super.id,
    required super.groupId,
    required super.sender,
    required super.content,
    required super.createdAt,
  });

  factory ChatGroupMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupMessageModel(
      id: json["id"],
      groupId: json["groupId"],
      sender: ChatGroupUserModel(
        id: json["sender"]["id"],
        name: "${json["sender"]["firstName"]} ${json["sender"]["lastName"]}",
        phone: json["sender"]["phone"],
      ),
      content: json["content"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
