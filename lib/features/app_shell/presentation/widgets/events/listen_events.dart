import "dart:async";

import "package:ciudadano/features/geolocalization/domain/usecases/connect_geolocalization_socket_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/disconnect_geolocalization_socket_use_case.dart";
import "package:ciudadano/features/geolocalization/presentation/widgets/geolocalization_provider.dart";
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

  @override
  void initState() {
    super.initState();
    _connectGeolocalizationSocketUseCase(context.read<CurrentLocation>());
    _incidentReportedSubscription = _watchIncidentReportedUseCase().listen(
      (incident) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _disconnectGeolocalizationSocketUseCase();
    _incidentReportedSubscription.cancel();
    super.dispose();
  }
}
