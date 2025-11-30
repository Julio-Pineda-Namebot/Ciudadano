import "dart:async";

import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class GetChatContactsState extends Equatable {
  const GetChatContactsState();
}

class GetChatContactsLoadingState extends GetChatContactsState {
  @override
  List<Object?> get props => [];
}

class GetChatContactsLoadedState extends GetChatContactsState {
  final List<ChatContact> contacts;

  const GetChatContactsLoadedState(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class GetChatContactsErrorState extends GetChatContactsState {
  final String message;

  const GetChatContactsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetChatContactsCubit extends Cubit<GetChatContactsState> {
  final ChatRepository chatRepository;

  StreamSubscription<List<ChatContact>>? _chatContactsSubscription;

  GetChatContactsCubit(this.chatRepository)
    : super(GetChatContactsLoadingState());

  void loadChatContacts() async {
    _chatContactsSubscription ??= chatRepository.watchChatContacts().listen(
      (contacts) {
        emit(GetChatContactsLoadedState(contacts));
      },
      onError: (error) {
        emit(GetChatContactsErrorState(error.toString()));
      },
    );
  }

  void refetchChatContacts() async {
    emit(GetChatContactsLoadingState());
    chatRepository.getChatContacts();
  }

  @override
  Future<void> close() {
    _chatContactsSubscription?.cancel();
    return super.close();
  }
}
