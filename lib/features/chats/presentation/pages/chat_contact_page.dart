import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_contact_messages_cursor_paginated_cubit.dart";
import "package:ciudadano/features/chats/presentation/widgets/custom_style_message.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_chat_core/flutter_chat_core.dart";
import "package:flutter_chat_ui/flutter_chat_ui.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:ciudadano/features/chats/presentation/hooks/use_chat.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:provider/provider.dart";

class ChatContactPage extends HookWidget {
  final ChatContact chatContact;

  const ChatContactPage({super.key, required this.chatContact});

  static const routeName = "/chats/contact";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${chatContact.firstName} ${chatContact.lastName}",
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: _ChatContactPageBody(chatContact: chatContact),
    );
  }
}

class _ChatContactPageBody extends HookWidget {
  final ChatContact chatContact;

  const _ChatContactPageBody({required this.chatContact});

  @override
  Widget build(BuildContext context) {
    final chatController = useChat();
    final currentUser = context.read<AuthProfile>();

    final chatRepositoryRef = useRef(sl<ChatRepository>());
    final chatRepository = chatRepositoryRef.value;

    final getMessagesPaginatedCubit = useBlocProvider(
      () =>
          sl<GetChatContactMessagesCursorPaginatedCubit>()
            ..loadChatContactMessagesPaginated(chatContact.id, null),
    );
    final getMessagesPaginatedCubitState = useBlocBuilder(
      getMessagesPaginatedCubit,
    );

    useEffect(() {
      if (getMessagesPaginatedCubitState
          is GetChatContactMessagesCursorPaginatedLoadedState) {
        final messages = getMessagesPaginatedCubitState.messagesPaginated;

        chatController.setMessages(
          messages.reversed.map((message) {
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
    }, [getMessagesPaginatedCubitState]);

    useEffect(() {
      chatRepository.joinContact(chatContact.id);
      return () {
        chatRepository.leaveContact();
      };
    }, [chatRepository, chatContact.id]);

    final usersMapped = {
      currentUser.id: User(
        id: currentUser.id,
        name: "${currentUser.firstName} ${currentUser.lastName}",
      ),
      chatContact.id: User(
        id: chatContact.id,
        name: "${chatContact.firstName} ${chatContact.lastName}",
      ),
    };

    if (getMessagesPaginatedCubitState
        is GetChatContactMessagesCursorPaginatedLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (getMessagesPaginatedCubitState
        is GetChatContactMessagesCursorPaginatedErrorState) {
      return Center(
        child: Text(
          getMessagesPaginatedCubitState.message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Chat(
      chatController: chatController,
      currentUserId: currentUser.id,
      resolveUser:
          (id) async => usersMapped[id] ?? User(id: id, name: "Unknown"),
      onMessageSend: (text) async {
        final temporalId = DateTime.now().toIso8601String();
        final temporalMessage = TextMessage(
          id: temporalId,
          text: text,
          createdAt: DateTime.now(),
          authorId: currentUser.id,
          deliveredAt: null,
        );

        chatController.insertMessage(temporalMessage);

        final result = await chatRepository.sendMessageToContact(
          chatContact.id,
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
}
