import "dart:typed_data";
import "dart:ui";

import "package:ciudadano/features/emergency/data/models/help_centers_model.dart";
import "package:flutter/material.dart";
import "package:latlong2/latlong.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";

class VerMapaPage extends StatefulWidget {
  final CentroModel centro;

  const VerMapaPage({super.key, required this.centro});

  @override
  State<VerMapaPage> createState() => _VerMapaPageState();
}

class _VerMapaPageState extends State<VerMapaPage> {
  late final MapboxMap _mapController;

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
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
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

  Future<void> _addMarker() async {
    final LatLng location = LatLng(widget.centro.lat, widget.centro.lng);
    final icon = _iconoPorTipo(widget.centro.tipo);

    const iconSize = 20.0;
    final canvasSize = (iconSize * 1.6).toInt();

    final imageBytes = await _iconToBytes(
      icon,
      Theme.of(context).colorScheme.primary,
      size: iconSize,
    );

    await _mapController.style.addStyleImage(
      "centro-marker",
      1.0,
      MbxImage(width: canvasSize, height: canvasSize, data: imageBytes),
      false,
      [],
      [],
      null,
    );

    await _mapController.annotations.createPointAnnotationManager().then((
      manager,
    ) async {
      await manager.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(location.longitude, location.latitude),
          ),
          iconImage: "centro-marker",
          iconSize: 1.5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(widget.centro.lat, widget.centro.lng);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.centro.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: MapWidget(
        onMapCreated: (MapboxMap mapboxMap) async {
          _mapController = mapboxMap;

          _mapController.location.updateSettings(
            LocationComponentSettings(enabled: true, pulsingEnabled: true),
          );
          _mapController.logo.updateSettings(LogoSettings(enabled: false));
          _mapController.attribution.updateSettings(
            AttributionSettings(enabled: false),
          );

          await _addMarker();
        },
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(location.longitude, location.latitude),
          ),
          zoom: 17,
          bearing: -15,
          pitch: 55,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          _mapController.flyTo(
            CameraOptions(
              center: Point(
                coordinates: Position(location.longitude, location.latitude),
              ),
              zoom: 17,
              bearing: -15,
              pitch: 55,
            ),
            MapAnimationOptions(duration: 1000),
          );
        },
        icon: const Icon(Icons.my_location),
        label: const Text("Centrar"),
      ),
    );
  }

  IconData _iconoPorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case "hospital":
        return Icons.local_hospital;
      case "comisaría":
        return Icons.local_police;
      case "bomberos":
        return Icons.local_fire_department;
      default:
        return Icons.location_on;
    }
  }
}
