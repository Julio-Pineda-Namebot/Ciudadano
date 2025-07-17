import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_map_compass/flutter_map_compass.dart";
import "package:flutter_map_location_marker/flutter_map_location_marker.dart";
import "package:latlong2/latlong.dart";
import "../bloc/route_bloc.dart";
import "../bloc/route_state.dart";

class SafeMap extends StatelessWidget {
  final LatLng currentLocation;
  final LatLng? destination;
  final void Function(LatLng) onTapMap;

  final MapController _mapController = MapController();

  SafeMap({
    super.key,
    required this.currentLocation,
    required this.destination,
    required this.onTapMap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 17.0,
        minZoom: 16.5,
        maxZoom: 17.5,
        onTap: (_, latlng) => onTapMap(latlng),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.ciudadano.app",
        ),
        const Positioned(bottom: 80, right: 8, child: MapCompass.cupertino()),
        Positioned(
          bottom: 20,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              _mapController.move(currentLocation, 17.0);
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: const Icon(Icons.my_location),
          ),
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
            if (destination != null)
              Marker(
                point: destination!,
                width: 40,
                height: 40,
                child: const Icon(Icons.flag, color: Colors.red),
              ),
          ],
        ),
        BlocBuilder<RouteBloc, RouteState>(
          builder: (context, state) {
            if (state is RouteLoaded) {
              final points =
                  state.steps.map((e) => LatLng(e.lat, e.lng)).toList();
              return PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    color: Colors.lightBlueAccent,
                    strokeWidth: 5,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
