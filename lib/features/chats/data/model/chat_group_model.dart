import "package:ciudadano/features/chats/domain/entity/chat_group.dart";

class ChatGroupModel extends ChatGroup {
  const ChatGroupModel({
    required super.id,
    required super.name,
    required super.description,
    required super.code,
    required super.createdAt,
  });

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      code: json["code"],
      createdAt: DateTime.parse(json["creation_date"]),
    );
  }
}
