import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:equatable/equatable.dart";

class ChatGroupMessage extends Equatable {
  final String id;
  final String content;
  final ChatGroupUser sender;
  final DateTime createdAt;
  final String groupId;

  const ChatGroupMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.createdAt,
    required this.groupId,
  });

  @override
  List<Object?> get props => [id, sender, content, createdAt, groupId];
}
