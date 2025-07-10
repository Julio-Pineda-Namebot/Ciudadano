import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";

class GetGroupsUseCase
    implements UseCase<Either<String, List<ChatGroup>>, void> {
  final ChatRepository _chatRepository;

  const GetGroupsUseCase(this._chatRepository);

  @override
  Future<Either<String, List<ChatGroup>>> call(void params) {
    return _chatRepository.getGroups();
  }
}
