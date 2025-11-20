import "package:ciudadano/features/chats/data/source/chat_api_source.dart";
import "package:ciudadano/features/chats/data/source/chat_local_source.dart";
import "package:ciudadano/features/chats/data/source/chat_ws_source.dart";
import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiSource _chatApiSource;
  final ChatLocalSource _chatLocalSource;
  final ChatWsSource _chatWsSource;

  const ChatRepositoryImpl(
    this._chatApiSource,
    this._chatLocalSource,
    this._chatWsSource,
  );

  @override
  Future<Either<String, List<ChatContact>>> getContacts() async {
    final contactsEither = await _chatLocalSource.getPhoneContacts();

    return contactsEither.fold((error) => Left(error), (phones) {
      if (phones.isEmpty) {
        return Future.value(const Right([]));
      }

      List<String> phonesMapped =
          phones
              .map(
                (phone) =>
                    phone.replaceAll(" ", "").replaceAll(RegExp(r"[^\d]"), ""),
              )
              .where((phone) => phone.isNotEmpty)
              .toSet()
              .toList();

      return _chatApiSource.getContactsByPhones(phonesMapped);
    });
  }

  @override
  Future<Either<String, List<ChatGroup>>> getGroups() {
    return _chatApiSource.getMyGroups();
  }

  @override
  Future<Either<String, ChatGroup>> createGroup(CreateChatGroup group) {
    return _chatWsSource.createGroup(group);
  }

  @override
  Future<Either<String, List<ChatMessage>>> getMessagesByGroup(String groupId) {
    return _chatApiSource.getMessagesByGroup(groupId);
  }

  @override
  Future<Either<String, ChatMessage>> sendMessageToGroup(
    String groupId,
    String content,
  ) {
    return _chatWsSource.sendMessageToGroup(content);
  }

  @override
  Future<Either<String, void>> joinChatGroup(String groupId) {
    return _chatWsSource.joinChatGroup(groupId);
  }

  @override
  Future<Either<String, void>> leaveChatGroup() {
    return _chatWsSource.leaveChatGroup();
  }
}
