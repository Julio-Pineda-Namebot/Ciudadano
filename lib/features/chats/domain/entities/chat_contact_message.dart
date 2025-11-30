import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:equatable/equatable.dart";

class ChatContactMessage extends Equatable {
  final String id;
  final String content;
  final ChatContact sender;
  final DateTime createdAt;

  const ChatContactMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, sender, createdAt];
}
