import "dart:async";

import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class GetChatGroupMessagesState extends Equatable {
  const GetChatGroupMessagesState();
}

class GetChatGroupMessagesLoadingState extends GetChatGroupMessagesState {
  const GetChatGroupMessagesLoadingState();

  @override
  List<Object?> get props => [];
}

class GetChatGroupMessagesSuccessState extends GetChatGroupMessagesState {
  final List<ChatGroupMessage> messages;

  const GetChatGroupMessagesSuccessState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class GetChatGroupMessagesErrorState extends GetChatGroupMessagesState {
  final String error;

  const GetChatGroupMessagesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class GetChatGroupMessagesCubit extends Cubit<GetChatGroupMessagesState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _streamSubscription;

  GetChatGroupMessagesCubit(this._chatRepository)
    : super(const GetChatGroupMessagesLoadingState());

  void loadChatGroupMessages(String groupId) async {
    emit(const GetChatGroupMessagesLoadingState());
    _streamSubscription ??= _chatRepository
        .watchChatGroupMessages(groupId)
        .listen(
          (messages) {
            emit(GetChatGroupMessagesSuccessState(messages));
          },
          onError: (error) {
            emit(GetChatGroupMessagesErrorState(error.toString()));
          },
        );
  }

  void refreshChatGroupMessages(String groupId) async {
    await _chatRepository.getCursorPaginatedChatGroupMessages(groupId, null);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
