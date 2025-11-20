import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";

class CreateChatGroupModel extends CreateChatGroup {
  const CreateChatGroupModel({
    required super.name,
    required super.description,
    required super.members,
  });

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "description": description, "memberIds": members};
  }
}
