import "package:ciudadano/features/sidebar/news/domain/entities/news.dart";

class NewsModel extends News {
  const NewsModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.content,
    required super.image,
    required super.date,
    required super.tag,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        title: json["title"],
        summary: json["summary"],
        content: json["content"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        tag: json["tag"],
      );
}
