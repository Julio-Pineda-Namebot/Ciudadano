import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:flutter/material.dart";

class IncidentMarkerTooltip extends StatelessWidget {
  final Incident incident;

  const IncidentMarkerTooltip({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Image.network(
            incident.multimediaUrl,
            width: 100,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 6),
          Text(
            incident.type.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            incident.description,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
