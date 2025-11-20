import "package:ciudadano/common/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/presentation/bloc/contacts/chat_contacts_bloc.dart";
import "package:ciudadano/features/chats/presentation/bloc/groups/chat_groups_bloc.dart";
import "package:ciudadano/features/chats/presentation/pages/chat_group_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";
import "package:skeletonizer/skeletonizer.dart";

class ChatGroupsList extends HookWidget {
  const ChatGroupsList({super.key});

  Widget _buildSkeletonView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Group $index"),
          subtitle: Text("Description for group $index"),
        );
      },
    );
  }

  Widget _buildContent(ChatGroupsState state, BuildContext context) {
    if (state is ChatGroupsLoaded) {
      return _buildChatListView(state.groups);
    }

    if (state is ChatGroupsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Error cargando los grupos"),
            TextButton(
              onPressed: () {
                context.read<ChatGroupsBloc>().add(const LoadChatGroupsEvent());
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

  Widget _buildChatListView(List<ChatGroup> groups) {
    if (groups.isEmpty) {
      return const Center(child: Text("No tienes grupos de chat"));
    }

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              group.name[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(group.name),
          subtitle: Text(group.description ?? ""),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatGroupPage(group: group),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatGroupsBloc = useBlocProvider(
      () => sl<ChatGroupsBloc>()..add(const LoadChatGroupsEvent()),
    );
    final chatGroupsState = useBloc<ChatGroupsBloc, ChatGroupsState>(
      bloc: chatGroupsBloc,
    );

    return BlocProvider.value(
      value: chatGroupsBloc,
      child: Skeletonizer(
        enabled:
            chatGroupsState is ChatGroupsInitial ||
            chatGroupsState is ChatGroupsLoading,
        child: _buildContent(chatGroupsState, context),
      ),
    );
  }
}
