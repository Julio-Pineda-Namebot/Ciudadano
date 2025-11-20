import "package:ciudadano/features/chats/domain/entity/chat_group.dart";

class ChatGroupModel extends ChatGroup {
  const ChatGroupModel({
    required super.id,
    required super.name,
    super.description,
    required super.createdAt,
  });

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
