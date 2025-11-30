import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_group_messages_cubit.dart";
import "package:ciudadano/features/chats/presentation/hooks/use_chat.dart";
import "package:ciudadano/features/chats/presentation/widgets/custom_style_message.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_chat_core/flutter_chat_core.dart";
import "package:flutter_chat_ui/flutter_chat_ui.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";

class ChatGroupPage extends HookWidget {
  const ChatGroupPage({super.key, required this.group});

  final ChatGroup group;

  Widget _buildBody({
    required BuildContext context,
    required GetChatGroupMessagesState? chatMessagesState,
    required ChatController chatController,
    required String currentUserId,
    required Map<String, User> usersMapped,
  }) {
    if (chatMessagesState == null ||
        chatMessagesState is GetChatGroupMessagesLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatMessagesState is GetChatGroupMessagesErrorState) {
      return Center(
        child: Text(
          chatMessagesState.error,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Chat(
      chatController: chatController,
      currentUserId: currentUserId,
      resolveUser:
          (id) async => usersMapped[id] ?? User(id: id, name: "Unknown"),
      onMessageSend: (text) async {
        final temporalId = DateTime.now().toIso8601String();
        final temporalMessage = TextMessage(
          id: temporalId,
          text: text,
          createdAt: DateTime.now(),
          authorId: currentUserId,
          deliveredAt: null,
        );

        chatController.insertMessage(temporalMessage);

        final result = await sl<ChatRepository>().sendMessageToGroup(
          group.id,
          text,
        );

        result.fold(
          (error) {
            chatController.updateMessage(
              temporalMessage,
              temporalMessage.copyWith(failedAt: DateTime.now()),
            );
          },
          (success) {
            chatController.updateMessage(
              temporalMessage,
              temporalMessage.copyWith(
                id: success.id,
                createdAt: success.createdAt,
                deliveredAt: success.createdAt,
              ),
            );
          },
        );
      },
      builders: Builders(
        composerBuilder:
            (context) => const Composer(hintText: "Escribe un mensaje..."),
        textMessageBuilder: (
          context,
          textMessage,
          index, {
          groupStatus,
          required isSentByMe,
        }) {
          return CustomStyleMessage(
            message: textMessage,
            index: index,
            isSentByMe: isSentByMe,
            usersMapped: usersMapped,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatController = useChat();
    final userProfile = context.read<AuthProfile>();
    final chatMessagesCubit = useBlocProvider(
      () => sl<GetChatGroupMessagesCubit>()..loadChatGroupMessages(group.id),
    );
    final chatMessages = useBlocBuilder(chatMessagesCubit);

    final usersMapped = useMemoized(() {
      if (chatMessages is GetChatGroupMessagesSuccessState) {
        return chatMessages.messages.map((msg) => msg.sender).toSet().fold(
          <String, User>{},
          (acc, user) {
            acc[user.id] = User(id: user.id, name: user.name);
            return acc;
          },
        );
      }
      return <String, User>{};
    }, [chatMessages]);

    useEffect(() {
      sl<ChatRepository>().joinGroup(group.id);
      return () {
        sl<ChatRepository>().leaveGroup();
      };
    }, []);

    useEffect(() {
      if (chatMessages is GetChatGroupMessagesSuccessState) {
        chatController.setMessages(
          chatMessages.messages.reversed.map((message) {
            return TextMessage(
              id: message.id,
              text: message.content,
              createdAt: message.createdAt,
              deliveredAt: message.createdAt,
              authorId: message.sender.id,
            );
          }).toList(),
        );
      }

      return null;
    }, [chatMessages]);

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name, style: const TextStyle(fontSize: 20)),
      ),
      body: _buildBody(
        context: context,
        chatMessagesState: chatMessages,
        chatController: chatController,
        currentUserId: userProfile.id,
        usersMapped: usersMapped,
      ),
    );
  }
}
