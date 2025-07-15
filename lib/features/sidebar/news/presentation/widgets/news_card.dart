import "package:ciudadano/features/sidebar/news/domain/entities/news.dart";
import "package:ciudadano/features/sidebar/news/presentation/widgets/news_detail_modal.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({super.key, required this.news});

  Color getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case "seguridad":
        return Colors.blue;
      case "robo":
        return Colors.red;
      case "clima":
        return Colors.teal;
      case "tránsito":
        return Colors.orange;
      case "salud":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat("d/M/y").format(news.date);
    final tagColor = getTagColor(news.tag);
    
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  news.tag,
                  style: TextStyle(fontSize: 12, color: tagColor),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Título
            Text(
              news.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            // Resumen
            Text(news.summary),

            const SizedBox(height: 12),

            // Fecha y leer más
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 4),
                    Text(formattedDate),
                  ],
                ),
                TextButton(
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder: (_) => NewsDetailModal(news: news),
                      ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text("Leer más"), Icon(Icons.arrow_right_alt)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
