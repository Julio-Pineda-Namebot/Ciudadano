import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_contacts_cubit.dart";
import "package:ciudadano/features/chats/presentation/pages/chat_contact_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:provider/provider.dart";
import "package:skeletonizer/skeletonizer.dart";

class ChatContactsList extends HookWidget {
  const ChatContactsList({super.key});

  Widget _buildSkeletonView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Contact $index"),
          subtitle: Text("Description for contact $index"),
        );
      },
    );
  }

  Widget _buildChatListView(List<ChatContact> contacts, BuildContext context) {
    if (contacts.isEmpty) {
      return const Center(child: Text("No tienes contactos de chat"));
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              contact.firstName.isNotEmpty
                  ? contact.firstName[0].toUpperCase()
                  : "?",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          title: Text("${contact.firstName} ${contact.lastName}"),
          subtitle: Text(contact.phone),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder:
                    (_) => Provider.value(
                      value: context.read<AuthProfile>(),
                      child: ChatContactPage(chatContact: contact),
                    ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(GetChatContactsState state, BuildContext context) {
    if (state is GetChatContactsLoadedState) {
      return _buildChatListView(state.contacts, context);
    }

    if (state is GetChatContactsErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(state.message)],
        ),
      );
    }

    return _buildSkeletonView();
  }

  @override
  Widget build(BuildContext context) {
    final getChatContactsCubit = useBlocProvider(
      () => sl<GetChatContactsCubit>()..loadChatContacts(),
    );
    final chatContactsState = useBlocBuilder(getChatContactsCubit);

    return BlocProvider.value(
      value: getChatContactsCubit,
      child: Skeletonizer(
        enabled: chatContactsState is GetChatContactsLoadingState,
        child: _buildContent(chatContactsState, context),
      ),
    );
  }
}
