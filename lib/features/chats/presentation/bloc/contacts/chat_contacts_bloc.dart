import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/usecases/get_contacts_by_phone_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:permission_handler/permission_handler.dart";

part "chat_contacts_event.dart";
part "chat_contacts_state.dart";

class ChatContactsBloc extends Bloc<ChatContactsEvent, ChatContactsState> {
  final GetContactsByPhoneUseCase _getContactsByPhoneUseCase;

  ChatContactsBloc(this._getContactsByPhoneUseCase)
    : super(const ChatContactsInitial()) {
    on<LoadChatContacts>(_onLoadChatContacts);
    on<RequestContactsPermission>(_onRequestContactsPermission);
  }

  ChatContactsError _handleError(String message) {
    if (message == "Permiso denegado") {
      return ChatContactsPermissionDenied(message);
    }

    if (message == "Permiso permanentemente denegado") {
      return ChatContactsPermissionPermanentlyDenied(message);
    }

    return ChatContactsError(message);
  }

  Future<void> _onLoadChatContacts(
    LoadChatContacts event,
    Emitter<ChatContactsState> emit,
  ) async {
    emit(const ChatContactsLoading());
    final result = await _getContactsByPhoneUseCase({});
    result.fold(
      (message) => emit(_handleError(message)),
      (contacts) => emit(ChatContactsLoaded(contacts)),
    );
  }

  Future<void> _onRequestContactsPermission(
    RequestContactsPermission event,
    Emitter<ChatContactsState> emit,
  ) async {
    final hasOpened = await openAppSettings();

    if (hasOpened) {
      emit(const ChatContactsLoading());
      final result = await _getContactsByPhoneUseCase({});
      result.fold(
        (message) => emit(_handleError(message)),
        (contacts) => emit(ChatContactsLoaded(contacts)),
      );
    } else {
      emit(
        const ChatContactsPermissionPermanentlyDenied(
          "Permiso permanentemente denegado",
        ),
      );
    }
  }
}
