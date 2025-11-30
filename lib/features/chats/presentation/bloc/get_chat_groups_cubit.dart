import "dart:async";

import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class GetChatGroupsState extends Equatable {
  const GetChatGroupsState();
}

class GetChatGroupsLoadingState extends GetChatGroupsState {
  const GetChatGroupsLoadingState();

  @override
  List<Object?> get props => [];
}

class GetChatGroupsSuccessState extends GetChatGroupsState {
  final List<ChatGroup> chatGroups;

  const GetChatGroupsSuccessState(this.chatGroups);

  @override
  List<Object?> get props => [chatGroups];
}

class GetChatGroupsErrorState extends GetChatGroupsState {
  final String error;

  const GetChatGroupsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetChatGroupsCubit extends Cubit<GetChatGroupsState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _streamSubscription;

  GetChatGroupsCubit(this._chatRepository)
    : super(const GetChatGroupsLoadingState());

  void loadChatGroups() async {
    emit(const GetChatGroupsLoadingState());
    _streamSubscription ??= _chatRepository.watchGroups().listen(
      (chatGroups) {
        emit(GetChatGroupsSuccessState(chatGroups));
      },
      onError: (error) {
        emit(GetChatGroupsErrorState(error.toString()));
      },
    );
  }

  void refreshChatGroups() async {
    await _chatRepository.getGroups();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
