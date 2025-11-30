import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class CreateChatGroupState extends Equatable {}

class CreateChatGroupInitialState extends CreateChatGroupState {
  @override
  List<Object?> get props => [];
}

class CreateChatGroupLoadingState extends CreateChatGroupState {
  @override
  List<Object?> get props => [];
}

class CreateChatGroupSuccessState extends CreateChatGroupState {
  @override
  List<Object?> get props => [];
}

class CreateChatGroupErrorState extends CreateChatGroupState {
  final String error;

  CreateChatGroupErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class CreateChatGroupCubit extends Cubit<CreateChatGroupState> {
  final ChatRepository _chatRepository;

  CreateChatGroupCubit(this._chatRepository)
    : super(CreateChatGroupInitialState());

  void createChatGroup(
    String name,
    String description,
    List<String> memberIds,
  ) async {
    emit(CreateChatGroupLoadingState());
    final result = await _chatRepository.createGroup(
      name,
      description,
      memberIds,
    );
    result.fold(
      (error) => emit(CreateChatGroupErrorState(error)),
      (chatGroup) => emit(CreateChatGroupSuccessState()),
    );
  }
}
