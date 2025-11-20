import "dart:async";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/usecases/get_messages_by_group_use_case.dart";
import "package:ciudadano/features/chats/domain/usecases/watch_chat_group_messages_use_case.dart";
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

// class GroupMessagesGlobalState extends Equatable {
//   final Map<String, GroupMessagesState> messagesGroupStatesMap;

//   const GroupMessagesGlobalState({this.messagesGroupStatesMap = const {}});

//   @override
//   List<Object?> get props => [messagesGroupStatesMap];
// }

class GroupMessagesCubit extends Cubit<GroupMessagesState> {
  final GetMessagesByGroupUseCase _getMessagesByGroupUseCase;
  final WatchChatGroupMessagesUseCase _watchChatGroupMessagesUseCase;
  StreamSubscription? _messagesSubscription;

  GroupMessagesCubit(
    this._getMessagesByGroupUseCase,
    this._watchChatGroupMessagesUseCase,
  ) : super(const GroupMessagesLoadingState());

  // @override
  // Future<void> close() {
  //   _cancelAllTimers();
  //   return super.close();
  // }

  // void _cancelAllTimers() {
  //   for (final timer in _timers.values) {
  //     timer?.cancel();
  //   }
  //   _timers.clear();
  // }

  // void _cancelTimerForGroup(String groupId) {
  //   _timers[groupId]?.cancel();
  //   _timers.remove(groupId);
  // }

  // void _startPeriodicUpdates(String groupId) {
  //   _cancelTimerForGroup(groupId);
  //   _timers[groupId] = Timer.periodic(
  //     const Duration(seconds: 5),
  //     (_) => _refreshMessagesForGroup(groupId),
  //   );
  // }

  // Future<void> _refreshMessagesForGroup(String groupId) async {
  //   // Solo actualizar si el grupo ya está cargado para evitar mostrar loading
  //   final currentState = state.messagesGroupStatesMap[groupId];
  //   if (currentState is! GroupMessagesLoadedState) return;

  //   final result = await _getMessagesByGroupUseCase(groupId);
  //   result.fold(
  //     (message) => emit(
  //       GroupMessagesGlobalState(
  //         messagesGroupStatesMap: {
  //           ...state.messagesGroupStatesMap,
  //           groupId: GroupMessagesErrorState(message),
  //         },
  //       ),
  //     ),
  //     (messages) {
  //       emit(
  //         GroupMessagesGlobalState(
  //           messagesGroupStatesMap: {
  //             ...state.messagesGroupStatesMap,
  //             groupId: GroupMessagesLoadedState(messages),
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> getMessagesByGroup(String groupId) async {
    emit(const GroupMessagesLoadingState());

    final result = await _getMessagesByGroupUseCase(groupId);
    result.fold((message) => emit(GroupMessagesErrorState(message)), (
      messages,
    ) {
      emit(GroupMessagesLoadedState(messages));
      _messagesSubscription ??= _watchChatGroupMessagesUseCase(groupId).listen((
        messages,
      ) {
        emit(GroupMessagesLoadedState(messages));
      });
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }

  // void stopPeriodicUpdates(String groupId) {
  //   _cancelTimerForGroup(groupId);
  // }

  // void addMessageToGroup(String groupId, ChatMessage message) {
  //   final currentState = state.messagesGroupStatesMap[groupId];
  //   if (currentState is GroupMessagesLoadedState) {
  //     final updatedMessages = List<ChatMessage>.from(
  //       currentState.messagesByGroup,
  //     )..insert(0, message);
  //     emit(
  //       GroupMessagesGlobalState(
  //         messagesGroupStatesMap: {
  //           ...state.messagesGroupStatesMap,
  //           groupId: GroupMessagesLoadedState(updatedMessages),
  //         },
  //       ),
  //     );
  //   }
  // }
}
