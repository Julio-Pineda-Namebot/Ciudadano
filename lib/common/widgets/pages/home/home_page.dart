import "package:ciudadano/features/home/comunity/presentation/pages/comunidad_page.dart";
import "package:ciudadano/features/home/emergency/presentation/pages/emergency_page.dart";
import "package:ciudadano/features/incidents/presentation/widgets/nearby_incidents_map.dart";
import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            SizedBox(height: 400, child: NearbyIncidentsMap()),
            const SizedBox(height: 16),

            // Botón de Emergencia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Acción al tocar el botón de emergencia
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Botón de Emergencia",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "Toca rápidamente 3 veces para activar",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Emergencia y Comunidad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Botón Emergencia
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmergenciaPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.phone, size: 30),
                            SizedBox(height: 8),
                            Text(
                              "Emergencia",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Números Importantes",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Botón Comunidad
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ComunidadPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.groups, size: 30),
                            const SizedBox(height: 8),
                            const Text(
                              "Comunidad",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "Activos",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
