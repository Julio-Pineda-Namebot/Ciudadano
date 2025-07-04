import "package:ciudadano/features/chats/domain/entity/send_message_to_group.dart";

class SendMessageToGroupModel extends SendMessageToGroup {
  const SendMessageToGroupModel(super.groupId, super.content);

  @override
  Map<String, dynamic> toJson() {
    return {"content": content};
  }
}
