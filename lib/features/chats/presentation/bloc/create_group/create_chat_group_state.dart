part of "create_chat_group_bloc.dart";

abstract class CreateChatGroupState extends Equatable {
  const CreateChatGroupState();

  @override
  List<Object?> get props => [];
}

class InitialCreateChatGroupState extends CreateChatGroupState {
  const InitialCreateChatGroupState();
}

class SubmittingCreateChatGroupState extends CreateChatGroupState {
  const SubmittingCreateChatGroupState();
}

class SuccessCreateChatGroupState extends CreateChatGroupState {
  final ChatGroup group;

  const SuccessCreateChatGroupState(this.group);

  @override
  List<Object?> get props => [group];
}

class FailureCreateChatGroupState extends CreateChatGroupState {
  final String message;

  const FailureCreateChatGroupState(this.message);

  @override
  List<Object?> get props => [message];
}
