import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";

class ChatContactModel extends ChatContact {
  const ChatContactModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      id: json["id"] as String,
      name:
          "${json["first_name"] as String} ${json["last_name"] as String? ?? ""}",
      phone: json["phone"] as String,
      email: json["email"] as String,
    );
  }
}
