import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_groups_cubit.dart";
import "package:ciudadano/features/chats/presentation/pages/chat_group_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:provider/provider.dart";
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

  Widget _buildContent(GetChatGroupsState state, BuildContext context) {
    if (state is GetChatGroupsSuccessState) {
      return _buildChatListView(state.chatGroups);
    }

    if (state is GetChatGroupsErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Error cargando los grupos"),
            TextButton(
              onPressed: () {
                context.read<GetChatGroupsCubit>().loadChatGroups();
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
              CupertinoPageRoute(
                builder:
                    (_) => Provider.value(
                      value: context.read<AuthProfile>(),
                      child: ChatGroupPage(group: group),
                    ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatGroupsCubit = useBlocProvider(
      () => sl<GetChatGroupsCubit>()..loadChatGroups(),
    );
    final chatGroupsState = useBlocBuilder(chatGroupsCubit);

    return BlocProvider.value(
      value: chatGroupsCubit,
      child: Skeletonizer(
        enabled: chatGroupsState is GetChatGroupsLoadingState,
        child: _buildContent(chatGroupsState, context),
      ),
    );
  }
}
