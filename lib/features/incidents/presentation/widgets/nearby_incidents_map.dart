import "dart:convert";
import "dart:typed_data";
import "dart:ui";

import "package:ciudadano/core/log/pr.dart";
import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/geolocalization/presentation/widgets/geolocalization_provider.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/presentation/bloc/get_nearby_incidents_cubit.dart";
import "package:ciudadano/features/incidents/presentation/widgets/incident_marker_tooltip.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart" hide Visibility;
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";

class NearbyIncidentsMap extends HookWidget {
  const NearbyIncidentsMap({super.key});

  static const String _sourceId = "incidents-source";
  static const String _layerId = "incidents-layer";
  static const String _imageIdPrefix = "incident-";

  IconData getIncidentIcon(IncidentType type) {
    switch (type) {
      case IncidentType.steal:
        return Icons.lock_open;
      case IncidentType.accident:
        return Icons.car_crash_outlined;
      case IncidentType.vandalism:
        return Icons.format_paint;
    }
  }

  Color getIncidentColor(IncidentType type) {
    switch (type) {
      case IncidentType.steal:
        return Colors.black;
      case IncidentType.accident:
        return Colors.red;
      case IncidentType.vandalism:
        return Colors.purple;
    }
  }

  Future<Uint8List> _iconToBytes(
    IconData icon,
    Color color, {
    double size = 60,
  }) async {
    final double canvasSize = size * 1.6;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        // importante: convertir el codePoint
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily, // SÍ funciona
          fontSize: size,
          color: color,
        ),
      ),
    );

    textPainter.layout();

    final offset = Offset(
      (canvasSize - textPainter.width) / 2,
      (canvasSize - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);

    final picture = recorder.endRecording();
    final image = await picture.toImage(canvasSize.toInt(), canvasSize.toInt());

    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }

  Future<void> _addIncidentImageToStyle(
    MapboxMap mapboxMap,
    IncidentType type,
  ) async {
    final imageId = "$_imageIdPrefix${type.name}";
    const iconSize = 20.0;
    final canvasSize = (iconSize * 1.6).toInt();

    final imageBytes = await _iconToBytes(
      getIncidentIcon(type),
      getIncidentColor(type),
      size: iconSize,
    );

    try {
      await mapboxMap.style.addStyleImage(
        imageId,
        1.0,
        MbxImage(width: canvasSize, height: canvasSize, data: imageBytes),
        false,
        [],
        [],
        null,
      );
    } catch (e) {
      pr("Error adding image to style: $e");
    }
  }

  Feature _createIncidentFeature(Incident incident) {
    return Feature(
      id: incident.id,
      geometry: Point(
        coordinates: Position(
          incident.location.longitude,
          incident.location.latitude,
        ),
      ),
      properties: {
        "id": incident.id,
        "type": incident.type.name,
        "icon": "$_imageIdPrefix${incident.type.name}",
      },
    );
  }

  Future<void> _onLoadNearbyIncidents(
    MapboxMap mapboxMap,
    List<Incident> incidents,
  ) async {
    final uniqueTypes = incidents.map((i) => i.type).toSet();
    await Future.wait(
      uniqueTypes.map((type) => _addIncidentImageToStyle(mapboxMap, type)),
    );

    final featureCollection = FeatureCollection(
      features: incidents.map(_createIncidentFeature).toList(),
    );
    final geojsonData = json.encode(featureCollection);

    final sourceExists = await mapboxMap.style.styleSourceExists(_sourceId);

    if (sourceExists) {
      await mapboxMap.style.setStyleSourceProperty(
        _sourceId,
        "data",
        geojsonData,
      );
    } else {
      await mapboxMap.style.addSource(
        GeoJsonSource(id: _sourceId, data: geojsonData),
      );

      await mapboxMap.style.addLayer(
        SymbolLayer(
          id: _layerId,
          sourceId: _sourceId,
          visibility: Visibility.VISIBLE,
          iconImage: "${_imageIdPrefix}steal",
          iconImageExpression: ["get", "icon"],
          iconSize: 1.5,
          iconAllowOverlap: true,
          iconIgnorePlacement: true,
          slot: LayerSlot.TOP,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapboxMapRef = useState<MapboxMap?>(null);
    final location = context.watch<CurrentLocation>();

    final selectedIncident = useState<Incident?>(null);
    final screenPosition = useState<Offset?>(null);

    final getNearbyIncidentsCubit = useBlocProvider(
      () => sl<GetNearbyIncidentsCubit>()..loadNearbyIncidents(location),
    );
    final nearbyIncidentsState = useBlocBuilder(getNearbyIncidentsCubit);

    useEffect(() {
      if (mapboxMapRef.value != null &&
          nearbyIncidentsState is GetNearbyIncidentsLoadedState) {
        _onLoadNearbyIncidents(
          mapboxMapRef.value!,
          nearbyIncidentsState.incidents,
        );
      }
      return null;
    }, [nearbyIncidentsState, mapboxMapRef.value]);

    void handleMapTap(MapContentGestureContext mapContext) async {
      final nearbyIncidentsState = getNearbyIncidentsCubit.state;
      if (nearbyIncidentsState is! GetNearbyIncidentsLoadedState) {
        return;
      }

      final tapPoint = mapContext.touchPosition;
      const radius = 10.0;

      final queryGeometry = RenderedQueryGeometry.fromScreenBox(
        ScreenBox(
          min: ScreenCoordinate(x: tapPoint.x - radius, y: tapPoint.y - radius),
          max: ScreenCoordinate(x: tapPoint.x + radius, y: tapPoint.y + radius),
        ),
      );

      final features = await mapboxMapRef.value!.queryRenderedFeatures(
        queryGeometry,
        RenderedQueryOptions(layerIds: [_layerId]),
      );
      if (features.isEmpty) {
        selectedIncident.value = null;
        screenPosition.value = null;
        return;
      }

      final firstFeature = features.first;
      if (firstFeature == null) {
        return;
      }

      final feature = firstFeature.queriedFeature.feature;
      final properties = feature["properties"] as Map?;
      if (properties == null) {
        return;
      }

      selectedIncident.value = nearbyIncidentsState.incidents.firstWhere(
        (incident) => incident.id == properties["id"],
      );
      screenPosition.value = Offset(tapPoint.x, tapPoint.y);
    }

    void dismissTooltip() {
      selectedIncident.value = null;
      screenPosition.value = null;
    }

    return Stack(
      children: [
        MapWidget(
          cameraOptions: CameraOptions(
            zoom: 16,
            center: Point(
              coordinates: Position(location.longitude, location.latitude),
            ),
          ),
          onMapCreated: (controller) {
            mapboxMapRef.value = controller;
            mapboxMapRef.value!.location.updateSettings(
              LocationComponentSettings(enabled: true, pulsingEnabled: true),
            );
            mapboxMapRef.value!.logo.updateSettings(
              LogoSettings(enabled: false),
            );
            mapboxMapRef.value!.attribution.updateSettings(
              AttributionSettings(enabled: false),
            );
          },
          onTapListener: handleMapTap,
        ),
        Positioned(
          bottom: 24,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () async {
              final map = mapboxMapRef.value;
              if (map != null) {
                await map.flyTo(
                  CameraOptions(
                    center: Point(
                      coordinates: Position(
                        location.longitude,
                        location.latitude,
                      ),
                    ),
                    zoom: 16,
                  ),
                  MapAnimationOptions(duration: 1000),
                );
              }
            },
            child: const Icon(Icons.my_location),
          ),
        ),
        if (selectedIncident.value != null && screenPosition.value != null)
          Positioned(
            left: screenPosition.value!.dx - 80,
            top: screenPosition.value!.dy - 150,
            child: TapRegion(
              onTapOutside: (event) => dismissTooltip(),
              child: IncidentMarkerTooltip(incident: selectedIncident.value!),
            ),
          ),
      ],
    );
  }
}
