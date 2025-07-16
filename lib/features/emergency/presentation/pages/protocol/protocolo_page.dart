import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class ProtocoloPage extends StatefulWidget {
  const ProtocoloPage({super.key});

  @override
  State<ProtocoloPage> createState() => _ProtocoloPageState();
}

class _ProtocoloPageState extends State<ProtocoloPage> {
  List<dynamic> protocolos = [];

  @override
  void initState() {
    super.initState();
    _cargarProtocolos();
  }

  Future<void> _cargarProtocolos() async {
    final String data = await rootBundle.loadString("assets/data/protocol.json");
    setState(() {
      protocolos = json.decode(data);
    });
  }

  IconData _getIcon(String titulo) {
    final lower = titulo.toLowerCase();
    if (lower.contains("incendio")) {
      return Icons.local_fire_department;
    }
    if (lower.contains("terremoto")) {
      return Icons.public;
    }
    if (lower.contains("robo") || lower.contains("asalto")) {
      return Icons.security;
    }
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Protocolo de Emergencia"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: protocolos.length,
        itemBuilder: (context, index) {
          final item = protocolos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(
                  _getIcon(item["titulo"]),
                  color: Colors.redAccent,
                ),
                title: Text(
                  item["titulo"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item["descripcion"],
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}