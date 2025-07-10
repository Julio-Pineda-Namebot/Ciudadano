import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";

class GetContactsByPhoneUseCase
    implements UseCase<Either<String, List<ChatContact>>, void> {
  final ChatRepository _chatRepository;

  const GetContactsByPhoneUseCase(this._chatRepository);

  @override
  Future<Either<String, List<ChatContact>>> call(void params) {
    return _chatRepository.getContacts();
  }
}
