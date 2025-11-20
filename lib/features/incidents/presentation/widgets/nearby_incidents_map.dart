import "package:ciudadano/common/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:ciudadano/features/incidents/presentation/widgets/incident_marker.dart";
import "package:ciudadano/service_locator.dart";
// import "package:ciudadano/features/incidents/presentation/widgets/your_location_marker.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import "package:flutter_map_compass/flutter_map_compass.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:lottie/lottie.dart" hide Marker;

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
    final nearbyIncidentsBloc = useBlocProvider(
      () => sl<NearbyIncidentsBloc>(),
    );
    final nearbyIncidentsState =
        useBloc<NearbyIncidentsBloc, NearbyIncidentsState>(
          bloc: nearbyIncidentsBloc,
        );

    final locationCubitState =
        useBloc<LocationCubit, LocationState>() as LocationLoadedState;

    useEffect(() {
      nearbyIncidentsBloc.add(LoadNearbyIncidents(locationCubitState.location));
      return null;
    }, []);

    return Skeletonizer(
      enabled:
          nearbyIncidentsState is NearbyIncidentsLoading ||
          nearbyIncidentsState is NearbyIncidentsInitial,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: locationCubitState.location,
              initialZoom: 17.0,
              minZoom: 16.5,
              maxZoom: 17.5,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.ciudadano.app",
              ),
              const MapCompass.cupertino(),
              const CurrentLocationLayer(
                alignPositionOnUpdate: AlignOnUpdate.always,
                alignDirectionOnUpdate: AlignOnUpdate.never,
                style: LocationMarkerStyle(
                  markerSize: Size(20, 20),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerLayer(
                markers: [
                  // Marker(
                  //   point: actualLocation,
                  //   width: 80,
                  //   height: 80,
                  //   child: const YourLocationMarker(),
                  // ),
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
            top: 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/lottie/alert_green.json",
                    width: 32,
                    height: 32,
                    repeat: true,
                    animate: true,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _mapController.move(locationCubitState.location, 17.0);
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
