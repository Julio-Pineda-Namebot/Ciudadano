import "package:ciudadano/features/home/comunity/domain/entities/cam_feed.dart";
import "package:flutter/material.dart";

class CamCard extends StatelessWidget {
  final CamFeed feed;
  const CamCard({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(feed.gifPath, fit: BoxFit.cover, height: 180),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              feed.titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
