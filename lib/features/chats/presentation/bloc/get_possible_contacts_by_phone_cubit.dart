import "package:ciudadano/features/chats/domain/entities/possible_contact.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class GetPossibleContactsByPhoneState extends Equatable {
  const GetPossibleContactsByPhoneState();
}

class GetPossibleContactsByPhoneLoadingState
    extends GetPossibleContactsByPhoneState {
  const GetPossibleContactsByPhoneLoadingState();

  @override
  List<Object?> get props => [];
}

class GetPossibleContactsByPhoneLoadedState
    extends GetPossibleContactsByPhoneState {
  final List<PossibleContact> contacts;

  const GetPossibleContactsByPhoneLoadedState(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class GetPossibleContactsByPhoneErrorState
    extends GetPossibleContactsByPhoneState {
  final String message;

  const GetPossibleContactsByPhoneErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetPossibleContactsByPhoneCubit
    extends Cubit<GetPossibleContactsByPhoneState> {
  final ChatRepository _chatRepository;

  GetPossibleContactsByPhoneCubit(this._chatRepository)
    : super(const GetPossibleContactsByPhoneLoadingState());

  void getPossibleContactsByPhone() async {
    emit(const GetPossibleContactsByPhoneLoadingState());

    final contactPhonesEither = await _chatRepository.getContactPhones();

    if (contactPhonesEither.isLeft()) {
      final message = contactPhonesEither.fold((l) => l, (r) => "");
      emit(GetPossibleContactsByPhoneErrorState(message));
      return;
    }

    final either = await _chatRepository.getPossibleContactsByPhoneNumbers(
      contactPhonesEither.getOrElse(() => []),
    );

    either.fold(
      (message) {
        emit(GetPossibleContactsByPhoneErrorState(message));
      },
      (contacts) {
        emit(GetPossibleContactsByPhoneLoadedState(contacts));
      },
    );
  }
}
