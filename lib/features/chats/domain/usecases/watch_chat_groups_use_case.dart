import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";

class WatchChatGroupsUseCase {
  const WatchChatGroupsUseCase(this._chatRepository);
  final ChatRepository _chatRepository;

  Stream<List<ChatGroup>> call() {
    return _chatRepository.watchGroups();
  }
}
