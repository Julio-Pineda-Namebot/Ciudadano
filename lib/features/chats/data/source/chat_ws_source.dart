import "dart:async";

import "package:ciudadano/core/log/pr.dart";
import "package:ciudadano/core/ws/socket_io_client.dart";
import "package:ciudadano/features/auth/data/interceptors/auth_interceptor.dart";
import "package:ciudadano/features/chats/data/models/chat_contact_message_model.dart";
import "package:ciudadano/features/chats/data/models/chat_contact_model.dart";
import "package:ciudadano/features/chats/data/models/chat_group_message_model.dart";
import "package:ciudadano/features/chats/data/models/chat_group_model.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";
import "package:ciudadano/service_locator.dart";
import "package:dartz/dartz.dart";

class ChatWsSource {
  final SocketIoClient _socketClient;

  const ChatWsSource(this._socketClient);

  void connect() {
    _socketClient.connect(
      namespace: "/chats",
      authData: {"token": sl<AuthInterceptor>().token},
    );
  }

  void disconnect() {
    _socketClient.dispose();
  }

  Stream<ChatContact> observeExternalChatContactCreated() {
    final controller = StreamController<ChatContact>();

    void onChatContactCreated(dynamic data) {
      final chatContact = ChatContactModel.fromJson(data["contact"]);
      controller.add(chatContact);
    }

    _socketClient.socket?.on("chat_contact:added", onChatContactCreated);

    controller.onCancel = () {
      _socketClient.socket?.off("chat_contact:added", onChatContactCreated);
    };

    return controller.stream;
  }

  Future<Either<String, ChatContact>> joinContact(String contactId) async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_contact:join",
      {"contact_id": contactId},
    );

    if (response["ok"] == false) {
      return Left(
        response["message"] ?? "Ocurrió un error al unirse al contacto",
      );
    }

    return Right(ChatContactModel.fromJson(response["data"]));
  }

  Future<Either<String, void>> leaveContact() async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_contact:leave",
      {},
    );

    if (response["ok"] == false) {
      return Left(
        response["message"] ?? "Ocurrió un error al salir del contacto",
      );
    }

    return const Right(null);
  }

  Future<Either<String, ChatContact>> addChatContact(String userId) async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_contact:add",
      {"user_contact_id": userId},
    );

    if (response["ok"] == false) {
      return Left(
        response["message"] ?? "Ocurrió un error al agregar el contacto",
      );
    }

    return Right(ChatContactModel.fromJson(response["data"]));
  }

  Future<Either<String, ChatContactMessage>> sendMessageToContact(
    String message,
  ) async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_contact:send_message",
      {"message": message},
    );

    if (response["ok"] == false) {
      return Left(
        response["message"] ?? "Ocurrió un error al enviar el mensaje",
      );
    }

    return Right(ChatContactMessageModel.fromJson(response["data"]));
  }

  Stream<ChatContactMessage> observeExternalChatContactMessageReceived() {
    final controller = StreamController<ChatContactMessage>();

    void onChatContactMessageReceived(dynamic data) {
      final chatContactMessage = ChatContactMessageModel.fromJson(
        data["contact_message"],
      );
      controller.add(chatContactMessage);
    }

    _socketClient.socket?.on(
      "chat_contact:message_sent",
      onChatContactMessageReceived,
    );

    controller.onCancel = () {
      _socketClient.socket?.off(
        "chat_contact:message_sent",
        onChatContactMessageReceived,
      );
    };

    return controller.stream;
  }

  Stream<ChatGroup> observeExternalChatGroupCreated() {
    final controller = StreamController<ChatGroup>();

    void onChatGroupCreated(dynamic data) {
      final chatGroup = ChatGroupModel.fromJson(data["group"]);
      controller.add(chatGroup);
    }

    _socketClient.socket?.on("chat_group:added", onChatGroupCreated);

    controller.onCancel = () {
      _socketClient.socket?.off("chat_group:added", onChatGroupCreated);
    };

    return controller.stream;
  }

  Future<Either<String, ChatGroup>> joinGroup(String groupId) async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_group:join",
      {"group_id": groupId},
    );

    if (response["ok"] == false) {
      return Left(response["message"] ?? "Ocurrió un error al unirse al grupo");
    }

    return Right(ChatGroupModel.fromJson(response["data"]));
  }

  Future<Either<String, void>> leaveGroup() async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_group:leave",
      {},
    );

    if (response["ok"] == false) {
      return Left(response["message"] ?? "Ocurrió un error al salir del grupo");
    }

    return const Right(null);
  }

  Future<Either<String, ChatGroupMessage>> sendMessageToGroup(
    String content,
  ) async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_group:send_message",
      {"message": content},
    );
    pr(response);
    if (response["ok"] == false) {
      return Left(
        response["message"] ?? "Ocurrió un error al enviar el mensaje",
      );
    }

    return Right(ChatGroupMessageModel.fromJson(response["data"]));
  }

  Future<Either<String, ChatGroup>> createGroup(
    String name,
    String description,
    List<String> memberIds,
  ) async {
    final response = await _socketClient.socket!.emitWithAckAsync(
      "chat_group:create",
      {"name": name, "description": description, "memberIds": memberIds},
    );

    if (response["ok"] == false) {
      return Left(response["message"] ?? "Ocurrió un error al crear el grupo");
    }

    return Right(ChatGroupModel.fromJson(response["data"]));
  }

  Stream<ChatGroupMessage> observeExternalChatGroupMessageReceived() {
    final controller = StreamController<ChatGroupMessage>();

    void onChatGroupMessageReceived(dynamic data) {
      final chatGroupMessage = ChatGroupMessageModel.fromJson(
        data["group_message"],
      );
      controller.add(chatGroupMessage);
    }

    _socketClient.socket?.on(
      "chat_group:message_sent",
      onChatGroupMessageReceived,
    );

    controller.onCancel = () {
      _socketClient.socket?.off(
        "chat_group:message_sent",
        onChatGroupMessageReceived,
      );
    };

    return controller.stream;
  }
}
