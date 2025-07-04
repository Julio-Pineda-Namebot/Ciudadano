import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/usecases/get_messages_by_group_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class GroupMessagesState extends Equatable {
  const GroupMessagesState();

  @override
  List<Object?> get props => [];
}

class GroupMessagesLoadingState extends GroupMessagesState {
  const GroupMessagesLoadingState();
}

class GroupMessagesLoadedState extends GroupMessagesState {
  final List<ChatMessage> messagesByGroup;

  const GroupMessagesLoadedState(this.messagesByGroup);

  @override
  List<Object?> get props => [messagesByGroup];
}

class GroupMessagesErrorState extends GroupMessagesState {
  final String message;

  const GroupMessagesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupMessagesGlobalState extends Equatable {
  final Map<String, GroupMessagesState> messagesGroupStatesMap;

  const GroupMessagesGlobalState({this.messagesGroupStatesMap = const {}});

  @override
  List<Object?> get props => [messagesGroupStatesMap];
}

class GroupMessagesCubit extends Cubit<GroupMessagesGlobalState> {
  final GetMessagesByGroupUseCase _getMessagesByGroupUseCase;

  GroupMessagesCubit(this._getMessagesByGroupUseCase)
    : super(const GroupMessagesGlobalState());

  Future<void> getMessagesByGroup(String groupId) async {
    emit(
      GroupMessagesGlobalState(
        messagesGroupStatesMap: {
          ...state.messagesGroupStatesMap,
          groupId: const GroupMessagesLoadingState(),
        },
      ),
    );

    final result = await _getMessagesByGroupUseCase(groupId);
    result.fold(
      (message) => emit(
        GroupMessagesGlobalState(
          messagesGroupStatesMap: {
            ...state.messagesGroupStatesMap,
            groupId: GroupMessagesErrorState(message),
          },
        ),
      ),
      (messages) {
        emit(
          GroupMessagesGlobalState(
            messagesGroupStatesMap: {
              ...state.messagesGroupStatesMap,
              groupId: GroupMessagesLoadedState(messages),
            },
          ),
        );
      },
    );
  }

  void addMessageToGroup(String groupId, ChatMessage message) {
    final currentState = state.messagesGroupStatesMap[groupId];
    if (currentState is GroupMessagesLoadedState) {
      final updatedMessages = List<ChatMessage>.from(
        currentState.messagesByGroup,
      )..add(message);
      emit(
        GroupMessagesGlobalState(
          messagesGroupStatesMap: {
            ...state.messagesGroupStatesMap,
            groupId: GroupMessagesLoadedState(updatedMessages),
          },
        ),
      );
    }
  }
}
