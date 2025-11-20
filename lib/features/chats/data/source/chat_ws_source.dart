import "package:ciudadano/config/api/api_config.dart";
import "package:ciudadano/features/chats/data/model/chat_group_model.dart";
import "package:ciudadano/features/chats/data/model/chat_message_model.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:ciudadano/service_locator.dart";
import "package:dartz/dartz.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:socket_io_client/socket_io_client.dart" as io;

class ChatWsSource {
  ChatWsSource() {
    connect();
  }

  late io.Socket _socket;

  final String url = ApiConfig.ac
      .replaceAll("http", "ws")
      .replaceAll("https", "wss");

  Future<void> connect() async {
    final token = await sl<FlutterSecureStorage>().read(key: "auth_token");
    print(url);
    _socket = io.io(
      "$url/chats",
      io.OptionBuilder()
          .setTransports(["websocket"])
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(20000)
          .setAuth({"token": token})
          .build(),
    );

    _socket.onConnect((_) {
      print("Connected to chat WebSocket");
    });

    _socket.onDisconnect((_) {
      print("Disconnected from chat WebSocket");
    });
  }

  Future<void> disconnect() async {
    _socket.disconnect();
  }

  Future<Either<String, ChatGroup>> createGroup(CreateChatGroup group) async {
    try {
      final response = await _socket.emitWithAckAsync(
        "chat_group:create",
        group.toJson(),
      );

      // Validamos que el backend devolvió un mapa esperado
      if (response == null) {
        return const Left("No hubo respuesta del servidor");
      }

      final chatGroup = ChatGroupModel.fromJson(response["data"]);
      return Right(chatGroup);
    } catch (e) {
      return Left("Error de conexión: $e");
    }
  }

  Future<Either<String, ChatMessage>> sendMessageToGroup(String content) async {
    try {
      final response = await _socket.emitWithAckAsync(
        "chat_group:send_message",
        {"message": content},
      );

      if (response == null) {
        return const Left("No hubo respuesta del servidor");
      }
      final chatMessage = ChatMessageModel.fromJson(response["data"]);
      return Right(chatMessage);
    } catch (e) {
      return Left("Error de conexión: $e");
    }
  }

  Future<Either<String, void>> joinChatGroup(String groupId) async {
    final response = await _socket.emitWithAckAsync("chat_group:join", {
      "group_id": groupId,
    });
    if (response == null) {
      return const Left("No hubo respuesta del servidor");
    }

    if (response is Map && response["ok"] == true) {
      return const Right(null);
    }

    return Left(response["message"] ?? "Error desconocido del servidor");
  }

  Future<Either<String, void>> leaveChatGroup() async {
    final response = await _socket.emitWithAckAsync("chat_group:leave", {});
    if (response == null) {
      return const Left("No hubo respuesta del servidor");
    }

    if (response is Map && response["ok"] == true) {
      return const Right(null);
    }

    return Left(response["message"] ?? "Error desconocido del servidor");
  }
}
