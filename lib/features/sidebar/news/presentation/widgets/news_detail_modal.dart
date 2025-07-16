import "package:ciudadano/features/sidebar/news/domain/entities/news.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class NewsDetailModal extends StatelessWidget {
  final News news;

  const NewsDetailModal({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat("d/M/y").format(news.date);

    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              formattedDate,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Image.network(news.image),

            const SizedBox(height: 12),

            Text(
              news.content,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}