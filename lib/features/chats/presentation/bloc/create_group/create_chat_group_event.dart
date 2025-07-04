part of "create_chat_group_bloc.dart";

abstract class CreateChatGroupEvent extends Equatable {
  const CreateChatGroupEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCreateChatGroupEvent extends CreateChatGroupEvent {
  final CreateChatGroup group;

  const SubmitCreateChatGroupEvent(this.group);

  @override
  List<Object?> get props => [group];
}
