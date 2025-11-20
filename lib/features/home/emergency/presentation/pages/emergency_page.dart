import "package:ciudadano/features/home/emergency/presentation/pages/centro_ayuda/help_centers_page.dart";
import "package:ciudadano/features/home/emergency/presentation/pages/numeros_emergencia/number_emergency_page.dart";
import "package:ciudadano/features/home/emergency/presentation/pages/protocol/protocol_page.dart";
import "package:flutter/material.dart";

class EmergenciaPage extends StatelessWidget {
  const EmergenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Emergencia",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBotonEmergencia(
              context,
              icon: Icons.phone,
              label: "Números de Emergencia",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NumerosEmergenciaPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildBotonEmergencia(
              context,
              icon: Icons.local_hospital,
              label: "Centros de Ayuda",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CentrosAyudaPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildBotonEmergencia(
              context,
              icon: Icons.warning_amber_rounded,
              label: "Protocolo de Emergencia",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProtocoloPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonEmergencia(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.black87),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
