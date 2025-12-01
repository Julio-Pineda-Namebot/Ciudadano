import "package:ciudadano/features/news/data/datasource/local_news_datasource.dart";
import "package:ciudadano/features/news/domain/entities/news.dart";
import "package:ciudadano/features/news/domain/repositories/news_repository.dart";

class NewsRepositoryImpl implements NewsRepository {
  final LocalNewsDataSource localDataSource;

  NewsRepositoryImpl(this.localDataSource);

  @override
  Future<List<News>> getAllNews() => localDataSource.getAllNews();
}
