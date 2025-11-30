import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class AddChatContactState extends Equatable {
  const AddChatContactState();
}

class AddChatContactInitialState extends AddChatContactState {
  const AddChatContactInitialState();

  @override
  List<Object?> get props => [];
}

class AddChatContactLoadingState extends AddChatContactState {
  const AddChatContactLoadingState();

  @override
  List<Object?> get props => [];
}

class AddChatContactSuccessState extends AddChatContactState {
  final ChatContact contact;

  const AddChatContactSuccessState(this.contact);

  @override
  List<Object?> get props => [];
}

class AddChatContactErrorState extends AddChatContactState {
  final String message;

  const AddChatContactErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddChatContactCubit extends Cubit<AddChatContactState> {
  final ChatRepository chatRepository;

  AddChatContactCubit(this.chatRepository)
    : super(const AddChatContactInitialState());
  Future<void> addChatContactCubit(String contactId) async {
    emit(const AddChatContactLoadingState());
    final result = await chatRepository.addChatContact(contactId);
    result.fold(
      (message) => emit(AddChatContactErrorState(message)),
      (contact) => emit(AddChatContactSuccessState(contact)),
    );
  }
}
