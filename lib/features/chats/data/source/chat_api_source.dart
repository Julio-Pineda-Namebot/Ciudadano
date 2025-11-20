import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/chats/data/model/chat_contact_model.dart";
import "package:ciudadano/features/chats/data/model/chat_group_model.dart";
import "package:ciudadano/features/chats/data/model/chat_message_model.dart";
import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entity/chat_group.dart";
import "package:ciudadano/features/chats/domain/entity/chat_message.dart";
import "package:ciudadano/features/chats/domain/entity/create_chat_group.dart";
import "package:ciudadano/service_locator.dart";
import "package:dartz/dartz.dart";
import "package:dio/dio.dart";

class ChatApiSource {
  final DioClient _dio = sl<DioClient>();

  Future<Either<String, List<ChatContact>>> getContactsByPhones(
    List<String> phones,
  ) async {
    try {
      final response = await _dio.get(
        "/chats/possible-contacts",
        queryParameters: {"phones": phones.join(",")},
      );
      final data = response.data["data"] as List;
      final contacts =
          data.map((item) {
            return ChatContactModel.fromJson(item);
          }).toList();

      return Right(contacts);
    } catch (e) {
      if (e is DioException) {
        return Left(
          e.response?.data["message"] ??
              "No se pudieron cargar los incidentes cercanos",
        );
      }
      return const Left("Error cargando contactos");
    }
  }

  Future<Either<String, List<ChatGroup>>> getMyGroups() async {
    try {
      final response = await _dio.get("/chats/groups/me");
      final data = response.data["data"] as List;
      final groups =
          data.map((item) {
            return ChatGroupModel.fromJson(item);
          }).toList();

      return Right(groups);
    } catch (e) {
      if (e is DioException) {
        return Left(
          e.response?.data["message"] ?? "No se pudieron cargar los grupos",
        );
      }
      return const Left("Error cargando grupos");
    }
  }

  Future<Either<String, ChatGroup>> createGroup(CreateChatGroup group) async {
    try {
      final response = await _dio.post("/chats/groups", data: group.toJson());
      final data = response.data["data"];
      return Right(ChatGroupModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return Left(e.response?.data["message"] ?? "No se pudo crear el grupo");
      }

      return const Left("Error creando grupo");
    }
  }

  Future<Either<String, ChatMessage>> sendMessageToGroup(
    String groupId,
    String content,
  ) async {
    try {
      final response = await _dio.post(
        "/chats/groups/$groupId/messages",
        data: {"message": content},
      );
      final data = response.data["data"];
      return Right(ChatMessageModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return Left(
          e.response?.data["message"] ?? "No se pudo enviar el mensaje",
        );
      }
      return const Left("Error enviando mensaje");
    }
  }

  Future<Either<String, List<ChatMessage>>> getMessagesByGroup(
    String groupId,
  ) async {
    try {
      final response = await _dio.get("/chats/groups/$groupId/messages");
      final data = response.data["data"]["items"] as List;
      final messages =
          data.map((item) {
            return ChatMessageModel.fromJson(item);
          }).toList();
      return Right(messages);
    } catch (e) {
      if (e is DioException) {
        return Left(
          e.response?.data["message"] ?? "No se pudo obtener los mensajes",
        );
      }
      return const Left("Error obteniendo mensajes");
    }
  }
}
