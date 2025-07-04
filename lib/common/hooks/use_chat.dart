import "package:flutter/material.dart";
import "package:flutter_chat_core/flutter_chat_core.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class _ChatController extends Hook<ChatController> {
  @override
  _ChatControllerState createState() => _ChatControllerState();
}

class _ChatControllerState extends HookState<ChatController, _ChatController> {
  late final ChatController controller;

  @override
  void initHook() {
    super.initHook();
    controller = InMemoryChatController();
  }

  @override
  ChatController build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

ChatController useChat() {
  return use(_ChatController());
}
