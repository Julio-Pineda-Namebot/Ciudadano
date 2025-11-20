import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:dartz/dartz.dart";

abstract class ChatRepository {
  Future<Either<String, List<ChatContact>>> getContacts();

  Future<Either<String, List<ChatGroup>>> getGroups();

  Future<Either<String, ChatGroup>> createGroup(CreateChatGroup group);

  Future<Either<String, ChatMessage>> sendMessageToGroup(
    String groupId,
    String content,
  );

  Future<Either<String, List<ChatMessage>>> getMessagesByGroup(String groupId);

  Future<Either<String, void>> joinChatGroup(String groupId);
  Future<Either<String, void>> leaveChatGroup();
}
