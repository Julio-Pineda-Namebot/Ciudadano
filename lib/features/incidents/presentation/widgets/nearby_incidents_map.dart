import "dart:typed_data";
import "dart:ui";

import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/presentation/bloc/get_nearby_incidents_cubit.dart";
import "package:ciudadano/features/incidents/presentation/widgets/incident_marker_tooltip.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:latlong2/latlong.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";

class NearbyIncidentsMap extends HookWidget {
  const NearbyIncidentsMap({super.key});

  @override
  Widget build(BuildContext context) {
    final locationState = useBlocBuilder(
      BlocProvider.of<GetLocationCubit>(context),
    );

    if (locationState.location == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _NearbyIncidentsMapLoaded(location: locationState.location!);
  }
}

class _NearbyIncidentsMapLoaded extends HookWidget {
  const _NearbyIncidentsMapLoaded({required this.location});

  final LatLng location;

  Future<void> _onMapCreated(
    MapboxMap controller,
    ObjectRef<MapboxMap?> mapboxMapRef,
    ObjectRef<PointAnnotationManager?> annotaionManagerRef,
  ) async {
    mapboxMapRef.value = controller;

    controller.logo.updateSettings(LogoSettings(enabled: false));
    controller.attribution.updateSettings(AttributionSettings(enabled: false));
    controller.location.updateSettings(
      LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );
    controller.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    controller.setBounds(CameraBoundsOptions(minZoom: 12.0, maxZoom: 19.0));

    annotaionManagerRef.value =
        await controller.annotations.createPointAnnotationManager();
  }

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

  Future<void> _onLoadNearbyIncidents(
    PointAnnotationManager annotaionManager,
    List<Incident> incidents,
  ) async {
    await annotaionManager.deleteAll();

    for (final incident in incidents) {
      annotaionManager.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              incident.location.longitude,
              incident.location.latitude,
            ),
          ),
          image: await _iconToBytes(
            getIncidentIcon(incident.type),
            getIncidentColor(incident.type),
            size: 80,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapboxMapRef = useRef<MapboxMap?>(null);
    final annotaionManagerRef = useRef<PointAnnotationManager?>(null);
    final locationMemoized = useMemoized(() => location, []);

    final selectedIncident = useState<Incident?>(null);
    final screenPosition = useState<Offset?>(null);

    final getNearbyIncidentsCubit = useBlocProvider(
      () =>
          sl<GetNearbyIncidentsCubit>()..loadNearbyIncidents(locationMemoized),
    );
    final nearbyIncidentsState = useBlocBuilder(getNearbyIncidentsCubit);

    useBlocListener(
      getNearbyIncidentsCubit,
      (_, value, __) async {
        if (mapboxMapRef.value == null || annotaionManagerRef.value == null) {
          return;
        }

        if (value is GetNearbyIncidentsLoadedState) {
          await _onLoadNearbyIncidents(
            annotaionManagerRef.value!,
            value.incidents,
          );
        }
      },
      listenWhen: (state) => state is GetNearbyIncidentsLoadedState,
    );

    useEffect(() {
      if (mapboxMapRef.value != null &&
          annotaionManagerRef.value != null &&
          nearbyIncidentsState is GetNearbyIncidentsLoadedState) {
        final tapEvent = annotaionManagerRef.value!.tapEvents(
          onTap: (annotation) async {
            final point = annotation.geometry;
            final screenPos = await mapboxMapRef.value!.pixelForCoordinate(
              point,
            );
            selectedIncident.value = nearbyIncidentsState.incidents.firstWhere(
              (incident) =>
                  incident.location.latitude == point.coordinates.lat &&
                  incident.location.longitude == point.coordinates.lng,
            );

            screenPosition.value = Offset(
              screenPos.x.toDouble(),
              screenPos.y.toDouble(),
            );
          },
        );

        return () {
          tapEvent.cancel();
        };
      }
      return null;
    }, [mapboxMapRef.value, annotaionManagerRef.value, nearbyIncidentsState]);

    void dismissTooltip() {
      selectedIncident.value = null;
      screenPosition.value = null;
    }

    // useEffect(() {
    //   if (mapboxMapRef.value != null) {
    //     mapboxMapRef.value!.addInteraction(
    //       TapInteraction.onMap((actionContext) {
    //         dismissTooltip();
    //       }),
    //     );
    //   }
    //   return null;
    // }, [mapboxMapRef.value]);

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
            _onMapCreated(controller, mapboxMapRef, annotaionManagerRef);
          },
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
