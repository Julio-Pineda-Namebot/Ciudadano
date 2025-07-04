part of "chat_groups_bloc.dart";

abstract class ChatGroupsEvent extends Equatable {
  const ChatGroupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatGroupsEvent extends ChatGroupsEvent {
  const LoadChatGroupsEvent();
}

class RefreshChatGroupsEvent extends ChatGroupsEvent {
  const RefreshChatGroupsEvent();
}

class ChatGroupCreatedEvent extends ChatGroupsEvent {
  final ChatGroup group;

  const ChatGroupCreatedEvent(this.group);

  @override
  List<Object?> get props => [group];
}
