import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";

class WatchChatGroupMessagesUseCase {
  final ChatRepository _chatRepository;

  WatchChatGroupMessagesUseCase(this._chatRepository);

  Stream<List<ChatMessage>> call(String groupId) {
    return _chatRepository.watchMessagesByGroup(groupId);
  }
}
