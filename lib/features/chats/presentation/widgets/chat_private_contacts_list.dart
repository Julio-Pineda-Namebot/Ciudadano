import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/presentation/bloc/contacts/chat_contacts_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";
import "package:skeletonizer/skeletonizer.dart";

class ChatPrivateContactsList extends HookWidget {
  const ChatPrivateContactsList({super.key});

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
      return const Center(
        child: Text("No se encontraron contactos disponibles."),
      );
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : "?",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(contact.name),
          subtitle: Text(contact.phone),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildContent(ChatContactsState state, BuildContext context) {
    if (state is ChatContactsLoaded) {
      return _buildChatListView(state.contacts, context);
    }

    if (state is ChatContactsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            TextButton(
              onPressed: () {
                state is ChatContactsPermissionPermanentlyDenied
                    ? context.read<ChatContactsBloc>().add(
                      const RequestContactsPermission(),
                    )
                    : context.read<ChatContactsBloc>().add(
                      const LoadChatContacts(),
                    );
              },
              child: const Text(
                "Reintentar",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _buildSkeletonView();
  }

  @override
  Widget build(BuildContext context) {
    final chatContactsState = useBloc<ChatContactsBloc, ChatContactsState>();

    return Skeletonizer(
      enabled:
          chatContactsState is ChatContactsInitial ||
          chatContactsState is ChatContactsLoading,
      child: _buildContent(chatContactsState, context),
    );
  }
}
