import "package:ciudadano/features/chats/presentation/pages/chat_contact_add_page.dart";
import "package:ciudadano/features/chats/presentation/pages/chat_groups_create_page.dart";
import "package:ciudadano/features/chats/presentation/widgets/chat_contacts_list.dart";
import "package:ciudadano/features/chats/presentation/widgets/chat_groups_list.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class ChatsPage extends HookWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Conversaciones",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (tabController.index == 1) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ChatContactAddPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatGroupsCreatePage(),
                      ),
                    );
                  }
                },
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
                      ChatContactsList(),
                      // ChatGroupsList(),
                      // ChatPrivateContactsList(),
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
