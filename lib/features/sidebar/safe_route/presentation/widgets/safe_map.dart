import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_compass/flutter_map_compass.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import "package:latlong2/latlong.dart";
import "../bloc/route_bloc.dart";
import "../bloc/route_state.dart";

class SafeMap extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? destination;
  final List<Incident> incidents;
  final void Function(LatLng) onTapMap;

  const SafeMap({
    super.key,
    required this.currentLocation,
    required this.destination,
    required this.incidents,
    required this.onTapMap,
  });

  @override
  State<SafeMap> createState() => _SafeMapState();
}

class _SafeMapState extends State<SafeMap> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteBloc, RouteState>(
      builder: (context, routeState) {
        List<LatLng> routePoints = [];

        if (routeState is RouteLoaded) {
          routePoints =
              routeState.steps.map((e) => LatLng(e.lat, e.lng)).toList();
          debugPrint("🗺️ Ruta cargada con ${routePoints.length} puntos");
        } else {
          debugPrint("🗺️ Estado de ruta: ${routeState.runtimeType}");
        }

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.currentLocation,
            initialZoom: 17.0,
            minZoom: 16.5,
            maxZoom: 17.5,
            onTap: (_, latlng) => widget.onTapMap(latlng),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: "com.ciudadano.app",
            ),
            // Polyline debe ir antes de los marcadores para que aparezca debajo
            if (routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    color: Colors.blue,
                    strokeWidth: 6.0,
                    borderColor: Colors.white,
                    borderStrokeWidth: 2.0,
                  ),
                ],
              ),
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
                if (widget.destination != null)
                  Marker(
                    point: widget.destination!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.flag, color: Colors.red, size: 40),
                  ),
                // Mostrar marcadores de incidencias
                ...widget.incidents.map(
                  (incident) => Marker(
                    point: incident.location,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: const Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 80,
              right: 8,
              child: MapCompass.cupertino(),
            ),
            Positioned(
              bottom: 20,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  _mapController.move(widget.currentLocation, 17.0);
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        );
      },
    );
  }
}
