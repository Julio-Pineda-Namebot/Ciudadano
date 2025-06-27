import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/incidents/presentation/widgets/nearby_incidents_map.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketConnectionState = useBloc<SocketBloc, SocketState>();

    useEffect(() {
      if (socketConnectionState is SocketInitial) {
        context.read<SocketBloc>().add(ConnectToSocketEvent());
      }
      return null;
    }, [socketConnectionState]);

    return Column(
      children: [
        SizedBox(height: 400, child: NearbyIncidentsMap()),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Contenido debajo del mapa"),
        ),
      ],
    );
  }
}
