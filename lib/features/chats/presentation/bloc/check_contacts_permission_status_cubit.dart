import "package:ciudadano/features/chats/domain/entities/contact_permission_status.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class CheckContactsPermissionStatusState extends Equatable {
  final ContactPermissionStatus? status;

  const CheckContactsPermissionStatusState(this.status);

  @override
  List<Object?> get props => [status];
}

class CheckContactsPermissionStatusCubit
    extends Cubit<CheckContactsPermissionStatusState> {
  final ChatRepository _chatRepository;

  CheckContactsPermissionStatusCubit(this._chatRepository)
    : super(const CheckContactsPermissionStatusState(null));

  void checkPermissionStatus() async {
    emit(const CheckContactsPermissionStatusState(null));
    final status = await _chatRepository.checkContactsPermissionStatus();
    emit(CheckContactsPermissionStatusState(status));
  }
}
