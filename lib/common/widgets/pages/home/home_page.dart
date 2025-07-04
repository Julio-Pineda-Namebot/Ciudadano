import "package:ciudadano/features/incidents/presentation/widgets/nearby_incidents_map.dart";
import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
