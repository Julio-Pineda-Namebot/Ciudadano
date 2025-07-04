import "package:ciudadano/features/chats/presentation/pages/chat_groups_create_page.dart";
import "package:ciudadano/features/chats/presentation/widgets/chat_groups_list.dart";
import "package:ciudadano/features/chats/presentation/widgets/chat_private_contacts_list.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class ChatsPage extends HookWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    final isGroup = useListenable(tabController).index == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Conversaciones",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Opacity(
                opacity: isGroup ? 1.0 : 0.4,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatGroupsCreatePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  tabs: const [Tab(text: "Grupos"), Tab(text: "Privados")],
                  controller: tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      ChatGroupsList(),
                      ChatPrivateContactsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
