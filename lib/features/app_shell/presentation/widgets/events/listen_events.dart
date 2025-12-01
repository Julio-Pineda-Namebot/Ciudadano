import "dart:async";

import "package:ciudadano/features/chats/data/source/chat_in_memory_stream_source.dart";
import "package:ciudadano/features/chats/data/source/chat_ws_source.dart";
import "package:ciudadano/features/chats/domain/repositories/chat_repository.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/connect_geolocalization_socket_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/disconnect_geolocalization_socket_use_case.dart";
import "package:ciudadano/features/geolocalization/presentation/widgets/geolocalization_provider.dart";
import "package:ciudadano/features/incidents/data/sources/incident_in_memory_stream_source.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/usecases/watch_incident_reported_use_case.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ListenEvents extends StatefulWidget {
  final Widget child;

  const ListenEvents({super.key, required this.child});

  @override
  State<ListenEvents> createState() => _ListenEventsState();
}

class _ListenEventsState extends State<ListenEvents> {
  final ConnectGeolocalizationSocketUseCase
  _connectGeolocalizationSocketUseCase =
      sl<ConnectGeolocalizationSocketUseCase>();
  final DisconnectGeolocalizationSocketUseCase
  _disconnectGeolocalizationSocketUseCase =
      sl<DisconnectGeolocalizationSocketUseCase>();

  // Incidents
  final WatchIncidentReportedUseCase _watchIncidentReportedUseCase =
      sl<WatchIncidentReportedUseCase>();
  late StreamSubscription<Incident> _incidentReportedSubscription;

  // Chats
  final ChatRepository _chatRepository = sl<ChatRepository>();
  final ChatWsSource _chatWsSource = sl<ChatWsSource>();
  late StreamSubscription _externalChatContactCreatedSubscription;
  late StreamSubscription _externalChatContactMessageReceivedSubscription;
  late StreamSubscription _externalChatGroupCreatedSubscription;
  late StreamSubscription _externalChatGroupMessageReceivedSubscription;

  @override
  void initState() {
    super.initState();
    _connectGeolocalizationSocketUseCase(context.read<CurrentLocation>());
    _incidentReportedSubscription = _watchIncidentReportedUseCase().listen(
      (incident) {},
    );
    _chatWsSource.connect();
    _externalChatContactCreatedSubscription = _chatRepository
        .observeExternalChatContactCreated()
        .listen((event) {});
    _externalChatContactMessageReceivedSubscription = _chatRepository
        .observeExternalChatContactMessageReceived()
        .listen((event) {});
    _externalChatGroupCreatedSubscription = _chatRepository
        .observeExternalChatGroupCreated()
        .listen((event) {});
    _externalChatGroupMessageReceivedSubscription = _chatRepository
        .observeExternalChatGroupMessageReceived()
        .listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _disconnectGeolocalizationSocketUseCase();
    _incidentReportedSubscription.cancel();
    _chatWsSource.disconnect();
    _externalChatContactCreatedSubscription.cancel();
    _externalChatContactMessageReceivedSubscription.cancel();
    _externalChatGroupCreatedSubscription.cancel();
    _externalChatGroupMessageReceivedSubscription.cancel();

    sl<IncidentInMemoryStreamSource>().clearNearbyIncidents();
    sl<ChatInMemoryStreamSource>().clearChatContactMessages(null);
    sl<ChatInMemoryStreamSource>().clearChatGroupMessages(null);
    sl<ChatInMemoryStreamSource>().clearChatContacts();
    sl<ChatInMemoryStreamSource>().clearChatGroups();
    super.dispose();
  }
}
