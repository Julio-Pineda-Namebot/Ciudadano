import 'package:ciudadano/features/home/incidents/presentation/page/map_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 400,
          child: MapPage(),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Contenido debajo del mapa"),
        ),
      ],
    );
  }
}
