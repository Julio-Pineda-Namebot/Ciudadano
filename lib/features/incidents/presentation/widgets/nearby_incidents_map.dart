import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";
import "package:hooks_bloc/hooks_bloc.dart";

class NearbyIncidentsMap extends HookWidget {
  const NearbyIncidentsMap({super.key});

  @override
  Widget build(BuildContext context) {
    final nearbyIncidentsBloc =
        useBloc<NearbyIncidentsBloc, NearbyIncidentsState>();

    throw UnimplementedError();
  }
}
