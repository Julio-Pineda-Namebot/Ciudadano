import "package:ciudadano/features/chats/presentation/bloc/group_messages/group_messages_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/groups/chat_groups_bloc.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

void incidentsCreated(BuildContext context) {
  context.read<SocketBloc>().add(
    ListenIncidentsReportedEvent((incident) {
      context.read<NearbyIncidentsBloc>().add(
        NearbyIncidentReportedEvent(incident),
      );
    }),
  );
}

void chatGroupCreated(BuildContext context) {
  context.read<SocketBloc>().add(
    ListenChatGroupCreatedEvent((chatGroup) {
      context.read<ChatGroupsBloc>().add(ChatGroupCreatedEvent(chatGroup));
    }),
  );
}

void chatGroupMessageSent(BuildContext context) {
  context.read<SocketBloc>().add(
    ListenChatGroupMessageSentEvent((chatMessage) {
      context.read<GroupMessagesCubit>().addMessageToGroup(
        chatMessage.groupId,
        chatMessage,
      );
    }),
  );
}
