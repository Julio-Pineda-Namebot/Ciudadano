import "dart:async";

import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/usecases/get_groups_use_case.dart";
import "package:ciudadano/features/chats/domain/usecases/watch_chat_groups_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "chat_groups_event.dart";
part "chat_groups_state.dart";

class ChatGroupsBloc extends Bloc<ChatGroupsEvent, ChatGroupsState> {
  final GetGroupsUseCase _getGroupsUseCase;
  final WatchChatGroupsUseCase _watchChatGroupsUseCase;
  StreamSubscription<List<ChatGroup>>? _groupsSubscription;

  ChatGroupsBloc(this._getGroupsUseCase, this._watchChatGroupsUseCase)
    : super(const ChatGroupsInitial()) {
    on<LoadChatGroupsEvent>(_onLoadChatGroups);
    on<_ChatGroupsStreamUpdatedEvent>(_onChatGroupsStreamUpdated);
    // on<RefreshChatGroupsEvent>(_onRefreshChatGroups);
    // on<ChatGroupCreatedEvent>(_onChatGroupCreated);
  }

  Future<void> _onLoadChatGroups(
    LoadChatGroupsEvent event,
    Emitter<ChatGroupsState> emit,
  ) async {
    emit(const ChatGroupsLoading());
    final result = await _getGroupsUseCase({});
    result.fold((message) => emit(ChatGroupsError(message)), (contacts) async {
      emit(ChatGroupsLoaded(contacts));
      _groupsSubscription ??= _watchChatGroupsUseCase().listen((contacts) {
        add(_ChatGroupsStreamUpdatedEvent(contacts));
      });
    });
  }

  Future<void> _onChatGroupsStreamUpdated(
    _ChatGroupsStreamUpdatedEvent event,
    Emitter<ChatGroupsState> emit,
  ) async {
    emit(ChatGroupsLoaded(event.chatGroups));
  }

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }

  // Future<void> _onRefreshChatGroups(
  //   RefreshChatGroupsEvent event,
  //   Emitter<ChatGroupsState> emit,
  // ) async {
  //   emit(const ChatGroupsLoading());
  //   final result = await _getGroupsUseCase({});
  //   result.fold(
  //     (message) => emit(ChatGroupsError(message)),
  //     (contacts) => emit(ChatGroupsLoaded(contacts)),
  //   );
  // }

  // void _onChatGroupCreated(
  //   ChatGroupCreatedEvent event,
  //   Emitter<ChatGroupsState> emit,
  // ) {
  //   if (state is ChatGroupsLoaded) {
  //     final currentState = state as ChatGroupsLoaded;
  //     final updatedGroups = List<ChatGroup>.from(currentState.groups)
  //       ..add(event.group);
  //     emit(ChatGroupsLoaded(updatedGroups));
  //   }
  // }
}
