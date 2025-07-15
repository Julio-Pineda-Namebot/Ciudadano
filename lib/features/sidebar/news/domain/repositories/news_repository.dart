import "package:ciudadano/features/sidebar/news/domain/entities/news.dart";

abstract class NewsRepository {
  Future<List<News>> getAllNews();
}