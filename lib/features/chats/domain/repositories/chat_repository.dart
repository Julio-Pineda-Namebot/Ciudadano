import "package:ciudadano/core/pagination/cursor_pagination.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";
import "package:ciudadano/features/chats/domain/entities/contact_permission_status.dart";
import "package:ciudadano/features/chats/domain/entities/possible_contact.dart";
import "package:dartz/dartz.dart";

abstract class ChatRepository {
  Future<ContactPermissionStatus> checkContactsPermissionStatus();
  Future<Either<String, List<String>>> getContactPhones();

  Future<Either<String, List<PossibleContact>>>
  getPossibleContactsByPhoneNumbers(List<String> phoneNumbers);

  Future<Either<String, ChatContact>> addChatContact(String userId);

  Future<Either<String, List<ChatContact>>> getChatContacts();
  Stream<List<ChatContact>> watchChatContacts();
  Stream<ChatContact> observeExternalChatContactCreated();

  Future<Either<String, ChatContact>> joinContact(String contactId);
  Future<Either<String, void>> leaveContact();

  Future<Either<String, CursorPagination<ChatContactMessage>>>
  getCursorPaginatedChatContactMessages(String contactId, String? cursor);
  Stream<List<ChatContactMessage>> watchChatContactMessages(String contactId);
  Stream<ChatContactMessage> observeExternalChatContactMessageReceived();

  Future<Either<String, ChatContactMessage>> sendMessageToContact(
    String contactId,
    String message,
  );

  // GROUPS
  Future<Either<String, List<ChatGroup>>> getGroups();
  Stream<List<ChatGroup>> watchGroups();
  Stream<ChatGroup> observeExternalChatGroupCreated();

  Future<Either<String, ChatGroup>> createGroup(
    String name,
    String description,
    List<String> memberIds,
  );

  Future<Either<String, ChatGroup>> joinGroup(String groupId);
  Future<Either<String, void>> leaveGroup();

  Future<Either<String, CursorPagination<ChatGroupMessage>>>
  getCursorPaginatedChatGroupMessages(String groupId, String? cursor);
  Stream<List<ChatGroupMessage>> watchChatGroupMessages(String groupId);
  Stream<ChatGroupMessage> observeExternalChatGroupMessageReceived();

  Future<Either<String, ChatGroupMessage>> sendMessageToGroup(
    String groupId,
    String content,
  );
}
