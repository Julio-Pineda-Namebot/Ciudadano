import "package:ciudadano/features/home/incidents/presentation/page/map_page.dart";
import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 400, child: MapPage()),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Contenido debajo del mapa"),
        ),
      ],
    );
  }
}
