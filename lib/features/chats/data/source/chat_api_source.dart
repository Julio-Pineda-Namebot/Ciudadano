import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/core/pagination/cursor_pagination.dart";
import "package:ciudadano/features/chats/data/models/chat_contact_message_model.dart";
import "package:ciudadano/features/chats/data/models/chat_contact_model.dart";
import "package:ciudadano/features/chats/data/models/chat_group_message_model.dart";
import "package:ciudadano/features/chats/data/models/chat_group_model.dart";
import "package:ciudadano/features/chats/data/models/possible_contact_model.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact.dart";
import "package:ciudadano/features/chats/domain/entities/chat_contact_message.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group.dart";
import "package:ciudadano/features/chats/domain/entities/chat_group_message.dart";
import "package:ciudadano/features/chats/domain/entities/possible_contact.dart";
import "package:dartz/dartz.dart";
import "package:dio/dio.dart";

class ChatApiSource {
  final DioClient _dioClient;

  const ChatApiSource(this._dioClient);

  Future<Either<String, List<PossibleContact>>>
  getPossibleContactsByPhoneNumbers(List<String> phoneNumbers) async {
    if (phoneNumbers.isEmpty) {
      return const Right([]);
    }

    try {
      final response = await _dioClient.get(
        "/chats/possible-contacts",
        queryParameters: {"phones": phoneNumbers.join(",")},
      );

      final possibleContacts =
          (response.data["data"] as List)
              .map((e) => PossibleContactModel.fromJson(e))
              .toList();

      return Right(possibleContacts);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ??
            "Error al obtener los posibles contactos",
      );
    }
  }

  Future<Either<String, List<ChatContact>>> getChatContacts() async {
    try {
      final response = await _dioClient.get("/chats/contacts/me");

      final chatContacts =
          (response.data["data"] as List)
              .map((e) => ChatContactModel.fromJson(e))
              .toList();

      return Right(chatContacts);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "Error al obtener los contactos",
      );
    }
  }

  Future<Either<String, CursorPagination<ChatContactMessage>>>
  getCursorPaginatedChatContactMessages(
    String contactId,
    String? cursor,
  ) async {
    try {
      final response = await _dioClient.get(
        "/chats/contacts/$contactId/messages",
        queryParameters: {if (cursor != null) "cursor": cursor},
      );

      final chatMessages = CursorPagination<ChatContactMessage>.fromJson(
        response.data["data"],
        (data) => ChatContactMessageModel.fromJson(data),
      );

      return Right(chatMessages);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "Error al obtener los mensajes",
      );
    }
  }

  Future<Either<String, List<ChatGroup>>> getGroups() async {
    try {
      final response = await _dioClient.get("/chats/groups/me");
      final data = response.data["data"] as List;
      final groups =
          data.map((item) {
            return ChatGroupModel.fromJson(item);
          }).toList();

      return Right(groups);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "No se pudieron cargar los grupos",
      );
    }
  }

  Future<Either<String, CursorPagination<ChatGroupMessage>>> getMessagesByGroup(
    String groupId,
  ) async {
    try {
      final response = await _dioClient.get("/chats/groups/$groupId/messages");
      final data = response.data["data"];
      final pagination = CursorPagination<ChatGroupMessage>.fromJson(
        data,
        (item) => ChatGroupMessageModel.fromJson(item),
      );
      return Right(pagination);
    } on DioException catch (e) {
      return Left(
        e.response?.data["message"] ?? "No se pudo obtener los mensajes",
      );
    }
  }
}
