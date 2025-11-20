part of "chat_groups_bloc.dart";

abstract class ChatGroupsEvent extends Equatable {
  const ChatGroupsEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatGroupsEvent extends ChatGroupsEvent {
  const LoadChatGroupsEvent();
}

class _ChatGroupsStreamUpdatedEvent extends ChatGroupsEvent {
  final List<ChatGroup> chatGroups;

  const _ChatGroupsStreamUpdatedEvent(this.chatGroups);
}
