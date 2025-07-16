import "package:ciudadano/features/emergency/data/datasource/emergency_local_datasource.dart";
import "package:ciudadano/features/emergency/data/models/contact_model.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class NumerosEmergenciaPage extends StatelessWidget {
  const NumerosEmergenciaPage({super.key});

  Future<void> _llamar(String numero) async {
    final Uri uri = Uri.parse("tel:$numero");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("No se pudo lanzar $numero");
    }
  }

  @override
  Widget build(BuildContext context) {
    final datasource = EmergenciaLocalDatasourceImpl();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Números de Emergencia",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<ContactoModel>>(
        future: datasource.cargarContactos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay datos disponibles"));
          }

          final contactos = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Contactos de Emergencia",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Números importantes para situaciones de emergencia",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              ...contactos.map((contacto) {
                return Card(
                  child: ListTile(
                    leading: Icon(_getIconFromName(contacto.icono)),
                    title: Text(contacto.nombre),
                    subtitle: Text(contacto.numero),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () => _llamar(contacto.numero),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              const Text(
                "Consejos de Emergencia",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Qué hacer en caso de emergencia"),
                      SizedBox(height: 8),
                      Text("• Mantenga la calma y evalúe la situación."),
                      Text("• Llame al número adecuado según la emergencia."),
                      Text("• Dé ubicación clara al operador."),
                      Text("• Siga las instrucciones del operador."),
                      Text("• Ayude a otros si es seguro hacerlo."),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  IconData _getIconFromName(String icono) {
    switch (icono) {
      case "local_police":
        return Icons.local_police;
      case "local_fire_department":
        return Icons.local_fire_department;
      case "local_hospital":
        return Icons.local_hospital;
      case "shield":
        return Icons.shield;
      default:
        return Icons.phone;
    }
  }
}
