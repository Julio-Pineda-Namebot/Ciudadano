import "package:ciudadano/core/usecases/use_case.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/entity/send_message_to_group.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:dartz/dartz.dart";

class SendMessageToGroupUseCase
    implements UseCase<Either<String, ChatMessage>, SendMessageToGroup> {
  final ChatRepository repository;

  const SendMessageToGroupUseCase(this.repository);

  @override
  Future<Either<String, ChatMessage>> call(SendMessageToGroup params) {
    return repository.sendMessageToGroup(params.groupId, params.content);
  }
}
