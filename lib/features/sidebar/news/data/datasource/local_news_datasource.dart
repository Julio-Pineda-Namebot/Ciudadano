import "dart:convert";
import "package:ciudadano/features/sidebar/news/data/models/news_model.dart";
import "package:flutter/services.dart";

abstract class LocalNewsDataSource {
  Future<List<NewsModel>> getAllNews();
}

class LocalNewsDataSourceImpl implements LocalNewsDataSource {
  @override
  Future<List<NewsModel>> getAllNews() async {
      final String response = await rootBundle.loadString(
        "assets/data/news.json",
      );
      final List data = json.decode(response);
      return data.map((e) => NewsModel.fromJson(e)).toList();
  }
}
