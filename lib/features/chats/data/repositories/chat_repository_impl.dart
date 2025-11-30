import "package:ciudadano/core/pagination/cursor_pagination.dart";
import "package:ciudadano/features/chats/data/source/chat_api_source.dart";
import "package:ciudadano/features/chats/data/source/chat_in_memory_stream_source.dart";
import "package:ciudadano/features/chats/data/source/chat_local_permission_source.dart";
import "package:ciudadano/features/chats/data/source/chat_ws_source.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";
import "package:ciudadano/features/chats/domain/entities/contact_permission_status.dart";
import "package:ciudadano/features/chats/domain/entities/possible_contact.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:dartz/dartz.dart";

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiSource _apiSource;
  final ChatInMemoryStreamSource _inMemorySource;
  final ChatWsSource _wsSource;
  final ChatLocalPermissionSource _localPermissionSource;

  ChatRepositoryImpl(
    this._apiSource,
    this._inMemorySource,
    this._wsSource,
    this._localPermissionSource,
  );

  @override
  Future<ContactPermissionStatus> checkContactsPermissionStatus() {
    return _localPermissionSource.requestPermission();
  }

  @override
  Future<Either<String, List<String>>> getContactPhones() {
    return _localPermissionSource.getContactPhones();
  }

  @override
  Future<Either<String, List<PossibleContact>>>
  getPossibleContactsByPhoneNumbers(List<String> phoneNumbers) {
    return _apiSource.getPossibleContactsByPhoneNumbers(phoneNumbers);
  }

  @override
  Future<Either<String, ChatContact>> addChatContact(String userId) {
    return _wsSource
        .addChatContact(userId)
        .then(
          (either) => either.fold((message) => Left(message), (contact) {
            _inMemorySource.addChatContact(contact);
            return Right(contact);
          }),
        );
  }

  @override
  Future<Either<String, List<ChatContact>>> getChatContacts() {
    return _apiSource.getChatContacts().then(
      (either) => either.fold(
        (message) {
          _inMemorySource.throwErrorChatContacts(message);
          return Left(message);
        },
        (contacts) {
          _inMemorySource.updateChatContacts(contacts);
          return Right(contacts);
        },
      ),
    );
  }

  @override
  Stream<List<ChatContact>> watchChatContacts() {
    if (_inMemorySource.currentChatContacts == null) {
      getChatContacts();
    }

    return _inMemorySource.chatContactsStream;
  }

  @override
  Stream<ChatContact> observeExternalChatContactCreated() {
    return _wsSource.observeExternalChatContactCreated().map((contact) {
      _inMemorySource.addChatContact(contact);
      return contact;
    });
  }

  @override
  Future<Either<String, ChatContact>> joinContact(String contactId) {
    return _wsSource.joinContact(contactId);
  }

  @override
  Future<Either<String, void>> leaveContact() {
    return _wsSource.leaveContact();
  }

  @override
  Future<Either<String, CursorPagination<ChatContactMessage>>>
  getCursorPaginatedChatContactMessages(String contactId, String? cursor) {
    return _apiSource
        .getCursorPaginatedChatContactMessages(contactId, cursor)
        .then(
          (either) => either.fold(
            (message) {
              if (cursor == null) {
                _inMemorySource.throwErrorChatContactMessages(
                  contactId,
                  message,
                );
              }
              return Left(message);
            },
            (pagination) {
              if (cursor == null) {
                _inMemorySource.updateChatContactMessages(
                  contactId,
                  pagination.items,
                );
                return Right(pagination);
              }

              final currentMessages =
                  _inMemorySource.currentChatContactMessages(contactId) ?? [];
              final updatedMessages = [...currentMessages, ...pagination.items];
              _inMemorySource.updateChatContactMessages(
                contactId,
                updatedMessages,
              );
              return Right(pagination);
            },
          ),
        );
  }

  @override
  Future<Either<String, ChatContactMessage>> sendMessageToContact(
    String contactId,
    String message,
  ) {
    return _wsSource
        .sendMessageToContact(message)
        .then(
          (either) =>
              either.fold((errorMessage) => Left(errorMessage), (sentMessage) {
                final currentMessages =
                    _inMemorySource.currentChatContactMessages(contactId) ?? [];
                final updatedMessages = [sentMessage, ...currentMessages];
                _inMemorySource.updateChatContactMessages(
                  contactId,
                  updatedMessages,
                );
                return Right(sentMessage);
              }),
        );
  }

  @override
  Stream<List<ChatContactMessage>> watchChatContactMessages(String contactId) {
    if (_inMemorySource.currentChatContactMessages(contactId) == null) {
      getCursorPaginatedChatContactMessages(contactId, null);
    }

    return _inMemorySource.chatContactMessagesStream(contactId);
  }

  @override
  Stream<ChatContactMessage> observeExternalChatContactMessageReceived() {
    return _wsSource.observeExternalChatContactMessageReceived().map((message) {
      final contactId = message.sender.id;
      final currentMessages = _inMemorySource.currentChatContactMessages(
        contactId,
      );

      if (currentMessages == null) {
        return message;
      }

      final updatedMessages = [message, ...currentMessages];
      _inMemorySource.updateChatContactMessages(contactId, updatedMessages);
      return message;
    });
  }

  @override
  Future<Either<String, ChatGroup>> createGroup(
    String name,
    String description,
    List<String> memberIds,
  ) {
    return _wsSource
        .createGroup(name, description, memberIds)
        .then(
          (either) => either.fold(
            (l) {
              _inMemorySource.throwErrorChatGroups(l);
              return Left(l);
            },
            (r) {
              _inMemorySource.addChatGroup(r);
              return Right(r);
            },
          ),
        );
  }

  @override
  Future<Either<String, CursorPagination<ChatGroupMessage>>>
  getCursorPaginatedChatGroupMessages(String groupId, String? cursor) {
    return _apiSource
        .getMessagesByGroup(groupId)
        .then(
          (either) => either.fold(
            (message) {
              _inMemorySource.throwErrorChatGroupMessages(groupId, message);
              return Left(message);
            },
            (pagination) {
              _inMemorySource.updateChatGroupMessages(
                groupId,
                pagination.items,
              );
              return Right(pagination);
            },
          ),
        );
  }

  @override
  Future<Either<String, List<ChatGroup>>> getGroups() {
    return _apiSource.getGroups().then(
      (either) => either.fold(
        (message) {
          _inMemorySource.throwErrorChatGroups(message);
          return Left(message);
        },
        (groups) {
          _inMemorySource.updateChatGroups(groups);
          return Right(groups);
        },
      ),
    );
  }

  @override
  Future<Either<String, ChatGroup>> joinGroup(String groupId) {
    return _wsSource.joinGroup(groupId);
  }

  @override
  Future<Either<String, void>> leaveGroup() {
    return _wsSource.leaveGroup();
  }

  @override
  Stream<List<ChatGroupMessage>> watchChatGroupMessages(String groupId) {
    if (_inMemorySource.currentChatGroupMessages(groupId) == null) {
      getCursorPaginatedChatGroupMessages(groupId, null);
    }

    return _inMemorySource.chatGroupMessagesStream(groupId);
  }

  @override
  Stream<List<ChatGroup>> watchGroups() {
    if (_inMemorySource.currentChatGroups == null) {
      getGroups();
    }

    return _inMemorySource.chatGroupsStream;
  }

  @override
  Future<Either<String, ChatGroupMessage>> sendMessageToGroup(
    String groupId,
    String content,
  ) {
    return _wsSource
        .sendMessageToGroup(content)
        .then(
          (either) => either.fold((errorMessage) => Left(errorMessage), (
            sentMessage,
          ) {
            final currentMessages =
                _inMemorySource.currentChatGroupMessages(groupId) ?? [];
            final updatedMessages = [sentMessage, ...currentMessages];
            _inMemorySource.updateChatGroupMessages(groupId, updatedMessages);
            return Right(sentMessage);
          }),
        );
  }

  @override
  Stream<ChatGroupMessage> observeExternalChatGroupMessageReceived() {
    return _wsSource.observeExternalChatGroupMessageReceived().map((message) {
      final groupId = message.groupId;
      final currentMessages = _inMemorySource.currentChatGroupMessages(groupId);

      if (currentMessages == null) {
        return message;
      }

      final updatedMessages = [message, ...currentMessages];
      _inMemorySource.updateChatGroupMessages(groupId, updatedMessages);
      return message;
    });
  }

  @override
  Stream<ChatGroup> observeExternalChatGroupCreated() {
    return _wsSource.observeExternalChatGroupCreated().map((group) {
      _inMemorySource.addChatGroup(group);
      return group;
    });
  }
}
