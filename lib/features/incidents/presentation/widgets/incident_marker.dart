import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class IncidentMarker extends StatefulWidget {
  final String description;
  final String type;
  final Color color;
  final String imageUrl;

  const IncidentMarker({
    super.key,
    required this.description,
    required this.type,
    required this.color,
    required this.imageUrl,
  });

  @override
  State<IncidentMarker> createState() => _IncidentMarkerState();
}

class _IncidentMarkerState extends State<IncidentMarker> {
  bool _showTooltip = false;

  void _toggleTooltip() {
    setState(() {
      _showTooltip = !_showTooltip;
    });
  }

  IconData getIncidentIcon(String type) {
    switch (type.toLowerCase()) {
      case "robo":
        return FontAwesomeIcons.gun;
      case "accidente":
        return FontAwesomeIcons.carBurst;
      case "vandalismo":
        return FontAwesomeIcons.sprayCan;
      default:
        return FontAwesomeIcons.triangleExclamation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _toggleTooltip,
          child: FaIcon(
            getIncidentIcon(widget.type),
            size: 30,
            color: widget.color,
          ),
        ),
        if (_showTooltip)
          Positioned(
            top: 40,
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      widget.imageUrl,
                      width: 100,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.white70,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
