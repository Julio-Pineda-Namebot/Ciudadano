part of "chat_contacts_bloc.dart";

abstract class ChatContactsState extends Equatable {
  const ChatContactsState();

  @override
  List<Object?> get props => [];
}

class ChatContactsInitial extends ChatContactsState {
  const ChatContactsInitial();
}

class ChatContactsLoading extends ChatContactsState {
  const ChatContactsLoading();
}

class ChatContactsLoaded extends ChatContactsState {
  final List<ChatContact> contacts;

  const ChatContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ChatContactsError extends ChatContactsState {
  final String message;

  const ChatContactsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatContactsPermissionDenied extends ChatContactsError {
  const ChatContactsPermissionDenied(super.message);
}

class ChatContactsPermissionPermanentlyDenied extends ChatContactsError {
  const ChatContactsPermissionPermanentlyDenied(super.message);
}
