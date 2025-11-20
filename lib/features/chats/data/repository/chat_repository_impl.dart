import "package:ciudadano/features/chats/data/source/chat_api_source.dart";
import "package:ciudadano/features/chats/data/source/chat_in_memory_source.dart";
import "package:ciudadano/features/chats/data/source/chat_local_source.dart";
import "package:ciudadano/features/chats/data/source/chat_ws_source.dart";
import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";
import "package:rxdart/rxdart.dart";

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiSource _chatApiSource;
  final ChatLocalSource _chatLocalSource;
  final ChatWsSource _chatWsSource;
  final ChatInMemorySource _chatInMemorySource;

  const ChatRepositoryImpl(
    this._chatApiSource,
    this._chatLocalSource,
    this._chatWsSource,
    this._chatInMemorySource,
  );

  @override
  Future<Either<String, List<ChatContact>>> getContacts() async {
    if (_chatInMemorySource.currentChatContacts.isNotEmpty) {
      return Right(_chatInMemorySource.currentChatContacts);
    }

    final contactsEither = await _chatLocalSource.getPhoneContacts();

    return contactsEither.fold((error) => Left(error), (phones) async {
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

      final contactsEither = await _chatApiSource.getContactsByPhones(
        phonesMapped,
      );

      return contactsEither.fold((error) => Left(error), (contacts) {
        _chatInMemorySource.setChatContacts(contacts);
        return Right(contacts);
      });
    });
  }

  @override
  Stream<List<ChatContact>> watchContacts() {
    return _chatInMemorySource.chatContactsStream;
  }

  @override
  Future<Either<String, List<ChatGroup>>> getGroups() async {
    if (_chatInMemorySource.currentChatGroups.isNotEmpty) {
      return Right(_chatInMemorySource.currentChatGroups);
    }

    return (await _chatApiSource.getMyGroups()).fold((error) => Left(error), (
      groups,
    ) {
      _chatInMemorySource.setChatGroups(groups);
      return Right(groups);
    });
  }

  @override
  Stream<List<ChatGroup>> watchGroups() {
    return _chatInMemorySource.chatGroupsStream;
  }

  @override
  Future<Either<String, ChatGroup>> createGroup(CreateChatGroup group) {
    return _chatWsSource.createGroup(group);
  }

  @override
  Future<Either<String, List<ChatMessage>>> getMessagesByGroup(
    String groupId,
  ) async {
    if (_chatInMemorySource.getMessagesByGroup(groupId) != null &&
        _chatInMemorySource.getMessagesByGroup(groupId)!.isNotEmpty) {
      return Future.value(
        Right(_chatInMemorySource.getMessagesByGroup(groupId)!),
      );
    }

    return (await _chatApiSource.getMessagesByGroup(groupId)).fold(
      (error) => Left(error),
      (messages) {
        _chatInMemorySource.setMessagesByGroup(groupId, messages);
        return Right(messages);
      },
    );
  }

  @override
  Stream<List<ChatMessage>> watchMessagesByGroup(String groupId) {
    final initialMessages$ = _chatInMemorySource.watchMessagesByGroup(groupId);
    final newMessages$ = _chatWsSource
        .watchNewGroupMessageByGroupId(groupId)
        .map((message) {
          _chatInMemorySource.addMessageToGroup(groupId, message);
          return _chatInMemorySource.getMessagesByGroup(groupId)!;
        });

    return initialMessages$.mergeWith([newMessages$]);
  }

  @override
  Future<Either<String, ChatMessage>> sendMessageToGroup(
    String groupId,
    String content,
  ) {
    return _chatWsSource.sendMessageToGroup(content).then((either) {
      return either.map((message) {
        _chatInMemorySource.addMessageToGroup(groupId, message);
        return message;
      });
    });
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
