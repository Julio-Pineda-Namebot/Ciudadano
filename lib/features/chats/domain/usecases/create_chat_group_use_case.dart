import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";

class CreateChatGroupUseCase
    implements UseCase<Either<String, ChatGroup>, CreateChatGroup> {
  final ChatRepository _chatRepository;

  const CreateChatGroupUseCase(this._chatRepository);

  @override
  Future<Either<String, ChatGroup>> call(CreateChatGroup group) {
    return _chatRepository.createGroup(group);
  }
}
