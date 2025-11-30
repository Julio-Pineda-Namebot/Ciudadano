import "package:ciudadano/features/chats/presentation/widgets/chat_groups_create_form.dart";
import "package:flutter/material.dart";

class ChatGroupsCreatePage extends StatelessWidget {
  const ChatGroupsCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear grupo")),
      body: const SingleChildScrollView(child: ChatGroupsCreateForm()),
    );
  }
}
