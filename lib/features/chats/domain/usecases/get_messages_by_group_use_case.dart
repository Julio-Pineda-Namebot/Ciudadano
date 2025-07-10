import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";

class GetMessagesByGroupUseCase
    implements UseCase<Either<String, List<ChatMessage>>, String> {
  final ChatRepository repository;

  const GetMessagesByGroupUseCase(this.repository);

  @override
  Future<Either<String, List<ChatMessage>>> call(String groupId) {
    return repository.getMessagesByGroup(groupId);
  }
}
