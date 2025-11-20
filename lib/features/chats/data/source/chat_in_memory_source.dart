import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:rxdart/rxdart.dart";

class ChatInMemorySource {
  final _chatContactsSubject = BehaviorSubject<List<ChatContact>>.seeded([]);
  final _chatGroupsSubject = BehaviorSubject<List<ChatGroup>>.seeded([]);
  final _chatMessagesByGroupSubject =
      BehaviorSubject<Map<String, List<ChatMessage>>>.seeded({});

  Stream<List<ChatContact>> get chatContactsStream =>
      _chatContactsSubject.stream;
  List<ChatContact> get currentChatContacts => _chatContactsSubject.value;

  Stream<List<ChatGroup>> get chatGroupsStream => _chatGroupsSubject.stream;
  List<ChatGroup> get currentChatGroups => _chatGroupsSubject.value;

  Stream<List<ChatMessage>> watchMessagesByGroup(String groupId) {
    return _chatMessagesByGroupSubject.stream.map((messagesMap) {
      return messagesMap[groupId] ?? [];
    });
  }

  List<ChatMessage>? getMessagesByGroup(String groupId) {
    final messagesMap = _chatMessagesByGroupSubject.value;
    return messagesMap[groupId];
  }

  void setMessagesByGroup(String groupId, List<ChatMessage> messages) {
    final messagesMap = _chatMessagesByGroupSubject.value;
    messagesMap[groupId] = messages;
    _chatMessagesByGroupSubject.add(messagesMap);
  }

  void addMessageToGroup(String groupId, ChatMessage message) {
    final messagesMap = _chatMessagesByGroupSubject.value;
    final updatedMessages = List<ChatMessage>.from(messagesMap[groupId] ?? [])
      ..insert(0, message);

    messagesMap[groupId] = updatedMessages;
    _chatMessagesByGroupSubject.add(messagesMap);
  }

  void setChatContacts(List<ChatContact> contacts) {
    _chatContactsSubject.add(contacts);
  }

  void setChatGroups(List<ChatGroup> groups) {
    _chatGroupsSubject.add(groups);
  }

  void addChatGroup(ChatGroup group) {
    final updatedGroups = List<ChatGroup>.from(currentChatGroups)..add(group);
    _chatGroupsSubject.add(updatedGroups);
  }

  void dispose() {
    _chatContactsSubject.close();
    _chatGroupsSubject.close();
    _chatMessagesByGroupSubject.close();
  }

  void clear() {
    _chatContactsSubject.add([]);
    _chatGroupsSubject.add([]);
    _chatMessagesByGroupSubject.add({});
  }
}
