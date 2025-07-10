abstract class SendMessageToGroup {
  final String groupId;
  final String content;

  const SendMessageToGroup(this.groupId, this.content);

  Map<String, dynamic> toJson();
}
