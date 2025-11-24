import "package:ciudadano/features/incidents/presentation/widgets/nearby_incidents_map.dart";
import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [SizedBox(height: 400, child: NearbyIncidentsMap())],
        ),
      ),
    );
  }
}
