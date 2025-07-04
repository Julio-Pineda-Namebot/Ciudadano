part of "chat_contacts_bloc.dart";

abstract class ChatContactsEvent extends Equatable {
  const ChatContactsEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatContacts extends ChatContactsEvent {
  const LoadChatContacts();
}

class RequestContactsPermission extends ChatContactsEvent {
  const RequestContactsPermission();
}
