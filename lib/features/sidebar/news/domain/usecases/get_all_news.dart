import "package:ciudadano/features/sidebar/news/domain/entities/news.dart";
import "package:ciudadano/features/sidebar/news/domain/repositories/news_repository.dart";

class GetAllNews {
  final NewsRepository repository;

  GetAllNews(this.repository);

  Future<List<News>> call() => repository.getAllNews();
}