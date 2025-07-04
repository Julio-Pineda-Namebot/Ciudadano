import "package:ciudadano/features/chats/data/model/send_message_to_group_model.dart";
import "package:ciudadano/features/chats/domain/usecases/send_message_to_group_use_case.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class SendMessageToGroupState {
  const SendMessageToGroupState();
}

class SendMessageToGroupInitialState extends SendMessageToGroupState {
  const SendMessageToGroupInitialState();
}

class SendMessageToGroupLoadingState extends SendMessageToGroupState {
  const SendMessageToGroupLoadingState();
}

class SendMessageToGroupErrorState extends SendMessageToGroupState {
  final String message;

  const SendMessageToGroupErrorState(this.message);
}

class SendMessageToGroupSuccessState extends SendMessageToGroupState {
  const SendMessageToGroupSuccessState();
}

class SendMessageToGroupCubit extends Cubit<SendMessageToGroupState> {
  final SendMessageToGroupUseCase _sendMessageToGroupUseCase;

  SendMessageToGroupCubit(this._sendMessageToGroupUseCase)
    : super(const SendMessageToGroupInitialState());

  Future<void> sendMessage(String groupId, String message) async {
    emit(const SendMessageToGroupLoadingState());

    final result = await _sendMessageToGroupUseCase(
      SendMessageToGroupModel(groupId, message),
    );
    result.fold(
      (error) => emit(SendMessageToGroupErrorState(error)),
      (success) => emit(const SendMessageToGroupSuccessState()),
    );
  }
}
