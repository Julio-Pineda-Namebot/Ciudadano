import "package:ciudadano/features/home/emergency/data/models/help_centers_model.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

class VerMapaPage extends StatefulWidget {
  final CentroModel centro;

  const VerMapaPage({super.key, required this.centro});

  @override
  State<VerMapaPage> createState() => _VerMapaPageState();
}

class _VerMapaPageState extends State<VerMapaPage> {
  final MapController _mapController = MapController();

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
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: location,
          initialZoom: 17.0,
          minZoom: 16.5,
          maxZoom: 17.5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.ciudadano.app",
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40,
                height: 40,
                point: location,
                child: Icon(
                  _iconoPorTipo(widget.centro.tipo),
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mapController.move(location, 17.0);
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
