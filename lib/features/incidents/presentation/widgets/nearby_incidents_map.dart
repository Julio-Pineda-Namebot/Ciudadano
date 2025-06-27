import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:ciudadano/features/incidents/presentation/widgets/incident_marker.dart";
import "package:ciudadano/features/incidents/presentation/widgets/your_location_marker.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:skeletonizer/skeletonizer.dart";

class NearbyIncidentsMap extends HookWidget {
  NearbyIncidentsMap({super.key});

  final MapController _mapController = MapController();

  Color _getIncidentColor(String type) {
    switch (type.toLowerCase()) {
      case "robo":
        return Colors.black;
      case "accidente":
        return Colors.red;
      case "vandalismo":
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nearbyIncidentsState =
        useBloc<NearbyIncidentsBloc, NearbyIncidentsState>();

    final locationCubit = useBloc<LocationCubit, LocationState>();
    final actualLocation = locationCubit.location!;

    useEffect(() {
      if (nearbyIncidentsState is NearbyIncidentsInitial) {
        context.read<NearbyIncidentsBloc>().add(LoadNearbyIncidents());
      }
      return null;
    }, [nearbyIncidentsState]);

    final socketConnectionState = useBloc<SocketBloc, SocketState>();

    useEffect(() {
      if (socketConnectionState is SocketConnectedState) {
        context.read<SocketBloc>().add(
          ListenIncidentsReportedEvent((incident) {
            context.read<NearbyIncidentsBloc>().add(
              NearbyIncidentReportedEvent(incident),
            );
          }),
        );
      }
      return null;
    }, [socketConnectionState]);

    return Skeletonizer(
      enabled:
          nearbyIncidentsState is NearbyIncidentsLoading ||
          nearbyIncidentsState is NearbyIncidentsInitial,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: actualLocation,
              initialZoom: 17.0,
              minZoom: 16.5,
              maxZoom: 17.5,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.app",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: actualLocation,
                    width: 80,
                    height: 80,
                    child: const YourLocationMarker(),
                  ),
                  if (nearbyIncidentsState is NearbyIncidentsLoaded)
                    ...nearbyIncidentsState.incidents.map(
                      (incident) => Marker(
                        point: incident.location,
                        width: 80,
                        height: 80,
                        child: IncidentMarker(
                          description: incident.description,
                          type: incident.incidentType,
                          imageUrl: incident.imageUrl ?? "",
                          color: _getIncidentColor(incident.incidentType),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _mapController.move(actualLocation, 17.0);
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: const Icon(Icons.my_location),
            ),
          ),
          if (nearbyIncidentsState is NearbyIncidentsError)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No pudimos cargar los incidentes cercanos.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
