part of "chat_groups_bloc.dart";

abstract class ChatGroupsState extends Equatable {
  const ChatGroupsState();

  @override
  List<Object?> get props => [];
}

class ChatGroupsInitial extends ChatGroupsState {
  const ChatGroupsInitial();
}

class ChatGroupsLoading extends ChatGroupsState {
  const ChatGroupsLoading();
}

class ChatGroupsLoaded extends ChatGroupsState {
  final List<ChatGroup> groups;

  const ChatGroupsLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class ChatGroupsError extends ChatGroupsState {
  final String message;

  const ChatGroupsError(this.message);

  @override
  List<Object?> get props => [message];
}
