import "package:ciudadano/common/hooks/use_chat.dart";
import "package:ciudadano/features/chats/data/model/send_message_to_group_model.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/usecases/send_message_to_group_use_case.dart";
import "package:ciudadano/features/chats/presentation/bloc/group_messages/group_messages_cubit.dart";
import "package:ciudadano/features/chats/presentation/widgets/custom_style_message.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_bloc.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_state.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_chat_core/flutter_chat_core.dart";
import "package:flutter_chat_ui/flutter_chat_ui.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";

class ChatGroupPage extends HookWidget {
  const ChatGroupPage({super.key, required this.group});

  final ChatGroup group;

  Widget _buildBody({
    required BuildContext context,
    required GroupMessagesState? chatMessagesState,
    required ChatController chatController,
    required String currentUserId,
    required Map<String, User> usersMapped,
  }) {
    if (chatMessagesState == null ||
        chatMessagesState is GroupMessagesLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatMessagesState is GroupMessagesErrorState) {
      return Center(
        child: Text(
          chatMessagesState.message,
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

        final result = await sl<SendMessageToGroupUseCase>().call(
          SendMessageToGroupModel(group.id, text),
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
            context.read<GroupMessagesCubit>().addMessageToGroup(
              group.id,
              success,
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
    final userProfile = useBloc<UserProfileBloc, UserProfileState>();
    final chatMessages =
        useBloc<GroupMessagesCubit, GroupMessagesGlobalState>()
            .messagesGroupStatesMap[group.id];

    final usersMapped = useMemoized(() {
      if (chatMessages is GroupMessagesLoadedState) {
        return chatMessages.messagesByGroup
            .map((msg) => msg.sender)
            .toSet()
            .fold(<String, User>{}, (acc, user) {
              acc[user.id] = User(id: user.id, name: user.name);
              return acc;
            });
      }
      return <String, User>{};
    }, [chatMessages]);

    useEffect(() {
      if (chatMessages == null) {
        context.read<GroupMessagesCubit>().getMessagesByGroup(group.id);
      }
      return null;
    }, []);

    useEffect(() {
      if (chatMessages is GroupMessagesLoadedState) {
        chatController.setMessages(
          chatMessages.messagesByGroup.map((message) {
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
        centerTitle: true,
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
