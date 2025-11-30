import "dart:async";

import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class GetChatContactMessagesCursorPaginatedState extends Equatable {}

class GetChatContactMessagesCursorPaginatedLoadingState
    extends GetChatContactMessagesCursorPaginatedState {
  @override
  List<Object?> get props => [];
}

class GetChatContactMessagesCursorPaginatedLoadedState
    extends GetChatContactMessagesCursorPaginatedState {
  final List<ChatContactMessage> messagesPaginated;

  GetChatContactMessagesCursorPaginatedLoadedState({
    required this.messagesPaginated,
  });

  @override
  List<Object?> get props => [messagesPaginated];
}

class GetChatContactMessagesCursorPaginatedErrorState
    extends GetChatContactMessagesCursorPaginatedState {
  final String message;

  GetChatContactMessagesCursorPaginatedErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetChatContactMessagesCursorPaginatedCubit
    extends Cubit<GetChatContactMessagesCursorPaginatedState> {
  final ChatRepository _chatRepository;

  StreamSubscription? _subscription;

  GetChatContactMessagesCursorPaginatedCubit(this._chatRepository)
    : super(GetChatContactMessagesCursorPaginatedLoadingState());

  void loadChatContactMessagesPaginated(
    String contactId,
    String? cursor,
  ) async {
    emit(GetChatContactMessagesCursorPaginatedLoadingState());

    _subscription = _chatRepository
        .watchChatContactMessages(contactId)
        .listen(
          (messages) {
            emit(
              GetChatContactMessagesCursorPaginatedLoadedState(
                messagesPaginated: messages,
              ),
            );
          },
          onError: (error) {
            emit(
              GetChatContactMessagesCursorPaginatedErrorState(
                message: error.toString(),
              ),
            );
          },
        );
  }

  void refetchChatContactMessagesPaginated(String contactId, String? cursor) {
    _chatRepository.getCursorPaginatedChatContactMessages(contactId, cursor);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
