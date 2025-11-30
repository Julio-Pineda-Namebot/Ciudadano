import "package:ciudadano/features/chats/domain/entities/chat_group.dart";

class ChatGroupModel extends ChatGroup {
  const ChatGroupModel({
    required super.id,
    required super.name,
    super.description,
    required super.createdAt,
    super.members = const [],
  });

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: DateTime.parse(json["createdAt"]),
      members:
          (json["members"] as List<dynamic>?)
              ?.map((e) => ChatGroupUserModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ChatGroupUserModel extends ChatGroupUser {
  const ChatGroupUserModel({
    required super.id,
    required super.name,
    required super.phone,
  });

  factory ChatGroupUserModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupUserModel(
      id: json["user"]["id"],
      name: "${json["user"]["firstName"]} ${json["user"]["lastName"]}",
      phone: json["user"]["phone"],
    );
  }
}
