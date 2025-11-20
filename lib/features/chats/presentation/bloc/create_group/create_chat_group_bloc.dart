import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:ciudadano/features/chats/domain/usecases/create_chat_group_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "create_chat_group_event.dart";
part "create_chat_group_state.dart";

class CreateChatGroupBloc
    extends Bloc<CreateChatGroupEvent, CreateChatGroupState> {
  final CreateChatGroupUseCase _createChatGroupUseCase;

  CreateChatGroupBloc(this._createChatGroupUseCase)
    : super(const InitialCreateChatGroupState()) {
    on<SubmitCreateChatGroupEvent>(_onSubmitCreateChatGroup);
  }

  Future<void> _onSubmitCreateChatGroup(
    SubmitCreateChatGroupEvent event,
    Emitter<CreateChatGroupState> emit,
  ) async {
    emit(const SubmittingCreateChatGroupState());
    final result = await _createChatGroupUseCase(event.group);

    result.fold(
      (failure) => emit(FailureCreateChatGroupState(failure)),
      (group) => emit(SuccessCreateChatGroupState(group)),
    );
  }
}
