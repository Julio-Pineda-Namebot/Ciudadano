import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";

class ChatContactModel extends ChatContact {
  const ChatContactModel({
    required super.id,
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.phone,
  });

  factory ChatContactModel.fromJson(Map<String, dynamic> json) {
    return ChatContactModel(
      id: json["id"] as String,
      userId: json["other_user"]["id"] as String,
      firstName: json["other_user"]["firstName"] as String,
      lastName: json["other_user"]["lastName"] as String,
      phone: json["other_user"]["phone"] as String,
    );
  }
}
