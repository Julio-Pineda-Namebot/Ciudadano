import "dart:async";

import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";
import "package:rxdart/rxdart.dart";

class ChatInMemoryStreamSource
    with
        _ChatContactsInMemoryStreamSourceMixin,
        _ChatContactMessagesInMemoryStreamSourceMixin,
        _ChatGroupMessagesInMemoryStreamSourceMixin,
        _ChatGroupsInMemoryStreamSourceMixin {
  ChatInMemoryStreamSource();
}

mixin _ChatContactsInMemoryStreamSourceMixin {
  final _chatContactsIncidents = BehaviorSubject<List<ChatContact>?>.seeded(
    null,
  );

  Stream<List<ChatContact>> get chatContactsStream =>
      _chatContactsIncidents.stream
          .where((contacts) => contacts != null)
          .cast<List<ChatContact>>();

  List<ChatContact>? get currentChatContacts =>
      _chatContactsIncidents.hasError ? null : _chatContactsIncidents.value;

  void updateChatContacts(List<ChatContact> contacts) {
    _chatContactsIncidents.add(contacts);
  }

  void throwErrorChatContacts(String error) {
    _chatContactsIncidents.addError(error);
  }

  void clearChatContacts() {
    _chatContactsIncidents.add(null);
  }

  void addChatContact(ChatContact contact) {
    final currentContacts = _chatContactsIncidents.valueOrNull;
    if (currentContacts != null) {
      _chatContactsIncidents.add([...currentContacts, contact]);
    }
  }
}

mixin _ChatGroupsInMemoryStreamSourceMixin {
  final _chatGroupsSubjects = BehaviorSubject<List<ChatGroup>?>.seeded(null);

  Stream<List<ChatGroup>> get chatGroupsStream =>
      _chatGroupsSubjects.stream
          .where((groups) => groups != null)
          .cast<List<ChatGroup>>();

  List<ChatGroup>? get currentChatGroups =>
      _chatGroupsSubjects.hasError ? null : _chatGroupsSubjects.value;

  void updateChatGroups(List<ChatGroup> groups) {
    _chatGroupsSubjects.add(groups);
  }

  void throwErrorChatGroups(String error) {
    _chatGroupsSubjects.addError(error);
  }

  void clearChatGroups() {
    _chatGroupsSubjects.add(null);
  }

  void addChatGroup(ChatGroup group) {
    final currentGroups = _chatGroupsSubjects.valueOrNull;
    if (currentGroups != null) {
      _chatGroupsSubjects.add([...currentGroups, group]);
    }
  }
}

mixin _ChatContactMessagesInMemoryStreamSourceMixin {
  final _chatContactMessagesSubjectsMapped =
      <String, BehaviorSubject<List<ChatContactMessage>?>>{};

  Stream<List<ChatContactMessage>> chatContactMessagesStream(String contactId) {
    if (!_chatContactMessagesSubjectsMapped.containsKey(contactId)) {
      _chatContactMessagesSubjectsMapped[contactId] = BehaviorSubject.seeded(
        null,
      );
    }

    return _chatContactMessagesSubjectsMapped[contactId]!.stream
        .where((messages) => messages != null)
        .cast<List<ChatContactMessage>>();
  }

  List<ChatContactMessage>? currentChatContactMessages(String contactId) {
    if (!_chatContactMessagesSubjectsMapped.containsKey(contactId)) {
      return null;
    }

    final subject = _chatContactMessagesSubjectsMapped[contactId]!;

    return subject.hasError ? null : subject.value;
  }

  void updateChatContactMessages(
    String contactId,
    List<ChatContactMessage> messages,
  ) {
    if (!_chatContactMessagesSubjectsMapped.containsKey(contactId)) {
      _chatContactMessagesSubjectsMapped[contactId] = BehaviorSubject.seeded(
        null,
      );
    }

    _chatContactMessagesSubjectsMapped[contactId]!.add(messages);
  }

  void throwErrorChatContactMessages(String contactId, String error) {
    if (!_chatContactMessagesSubjectsMapped.containsKey(contactId)) {
      _chatContactMessagesSubjectsMapped[contactId] = BehaviorSubject.seeded(
        null,
      );
    }

    _chatContactMessagesSubjectsMapped[contactId]!.addError(error);
  }

  void clearChatContactMessages(String? contactId) {
    if (contactId != null) {
      if (!_chatContactMessagesSubjectsMapped.containsKey(contactId)) {
        _chatContactMessagesSubjectsMapped[contactId] = BehaviorSubject.seeded(
          null,
        );
      }

      _chatContactMessagesSubjectsMapped[contactId]!.add(null);
    } else {
      for (final subject in _chatContactMessagesSubjectsMapped.values) {
        subject.close();
      }
      _chatContactMessagesSubjectsMapped.clear();
    }
  }

  void addChatContactMessage(String contactId, ChatContactMessage message) {
    if (!_chatContactMessagesSubjectsMapped.containsKey(contactId)) {
      _chatContactMessagesSubjectsMapped[contactId] = BehaviorSubject.seeded(
        null,
      );
    }

    final currentMessages =
        _chatContactMessagesSubjectsMapped[contactId]!.valueOrNull;
    if (currentMessages != null) {
      _chatContactMessagesSubjectsMapped[contactId]!.add([
        ...currentMessages,
        message,
      ]);
    }
  }
}

mixin _ChatGroupMessagesInMemoryStreamSourceMixin {
  final _chatGroupMessagesSubjectsMapped =
      <String, BehaviorSubject<List<ChatGroupMessage>?>>{};

  Stream<List<ChatGroupMessage>> chatGroupMessagesStream(String groupId) {
    if (!_chatGroupMessagesSubjectsMapped.containsKey(groupId)) {
      _chatGroupMessagesSubjectsMapped[groupId] = BehaviorSubject.seeded(null);
    }

    return _chatGroupMessagesSubjectsMapped[groupId]!.stream
        .where((messages) => messages != null)
        .cast<List<ChatGroupMessage>>();
  }

  List<ChatGroupMessage>? currentChatGroupMessages(String groupId) {
    if (!_chatGroupMessagesSubjectsMapped.containsKey(groupId)) {
      return null;
    }

    final subject = _chatGroupMessagesSubjectsMapped[groupId]!;

    return subject.hasError ? null : subject.value;
  }

  void updateChatGroupMessages(
    String groupId,
    List<ChatGroupMessage> messages,
  ) {
    if (!_chatGroupMessagesSubjectsMapped.containsKey(groupId)) {
      _chatGroupMessagesSubjectsMapped[groupId] = BehaviorSubject.seeded(null);
    }

    _chatGroupMessagesSubjectsMapped[groupId]!.add(messages);
  }

  void throwErrorChatGroupMessages(String groupId, String error) {
    if (!_chatGroupMessagesSubjectsMapped.containsKey(groupId)) {
      _chatGroupMessagesSubjectsMapped[groupId] = BehaviorSubject.seeded(null);
    }

    _chatGroupMessagesSubjectsMapped[groupId]!.addError(error);
  }

  void clearChatGroupMessages(String? groupId) {
    if (groupId != null) {
      if (!_chatGroupMessagesSubjectsMapped.containsKey(groupId)) {
        _chatGroupMessagesSubjectsMapped[groupId] = BehaviorSubject.seeded(
          null,
        );
      }

      _chatGroupMessagesSubjectsMapped[groupId]!.add(null);
    } else {
      for (final subject in _chatGroupMessagesSubjectsMapped.values) {
        subject.close();
      }
      _chatGroupMessagesSubjectsMapped.clear();
    }
  }

  void addChatGroupMessage(String groupId, ChatGroupMessage message) {
    if (!_chatGroupMessagesSubjectsMapped.containsKey(groupId)) {
      _chatGroupMessagesSubjectsMapped[groupId] = BehaviorSubject.seeded(null);
    }

    final currentMessages =
        _chatGroupMessagesSubjectsMapped[groupId]!.valueOrNull;
    if (currentMessages != null) {
      _chatGroupMessagesSubjectsMapped[groupId]!.add([
        ...currentMessages,
        message,
      ]);
    }
  }
}
