import "package:ciudadano/features/geolocalization/presentation/widgets/geolocalization_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";

class SafeMap extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng? destination;
  final void Function(LatLng) onTapMap;

  const SafeMap({
    super.key,
    required this.currentLocation,
    required this.destination,
    required this.onTapMap,
  });

  @override
  State<SafeMap> createState() => _SafeMapState();
}

class _SafeMapState extends State<SafeMap> {
  late final MapboxMap _mapController;

  @override
  Widget build(BuildContext context) {
    final currentLocation = context.read<CurrentLocation>();

    return MapWidget(
      cameraOptions: CameraOptions(
        zoom: 16,
        center: Point(
          coordinates: Position(
            currentLocation.longitude,
            currentLocation.latitude,
          ),
        ),
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        _mapController.location.updateSettings(
          LocationComponentSettings(enabled: true, pulsingEnabled: true),
        );
        _mapController.logo.updateSettings(LogoSettings(enabled: false));
        _mapController.attribution.updateSettings(
          AttributionSettings(enabled: false),
        );
      },
    );
  }
}
