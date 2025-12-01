import "package:ciudadano/features/news/domain/entities/news.dart";

abstract class NewsRepository {
  Future<List<News>> getAllNews();
}
