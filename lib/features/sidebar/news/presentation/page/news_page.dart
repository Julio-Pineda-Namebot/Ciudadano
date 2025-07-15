import "package:ciudadano/features/sidebar/news/data/datasource/local_news_datasource.dart";
import "package:ciudadano/features/sidebar/news/data/repositories/news_repository_impl.dart";
import "package:ciudadano/features/sidebar/news/domain/entities/news.dart";
import "package:ciudadano/features/sidebar/news/domain/usecases/get_all_news.dart";
import "package:ciudadano/features/sidebar/news/presentation/widgets/news_card.dart";
import "package:ciudadano/features/sidebar/news/presentation/widgets/news_filter_widget.dart";
import "package:flutter/material.dart";

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<News> _allNews = [];
  List<News> _filteredNews = [];

  String _selectedTag = "Todos";
  DateTimeRange? _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 14)),
    end: DateTime.now(),
  );

  final List<String> _tags = [
    "Todos",
    "seguridad",
    "robo",
    "clima",
    "tránsito",
    "salud",
  ];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    final dataSource = LocalNewsDataSourceImpl();
    final repo = NewsRepositoryImpl(dataSource);
    final useCase = GetAllNews(repo);

    final news = await useCase();
    setState(() {
      _allNews = news;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<News> filtered = List.from(_allNews);

    if (_selectedTag != "Todos") {
      filtered =
          filtered
              .where((n) => n.tag.toLowerCase() == _selectedTag.toLowerCase())
              .toList();
    }

    if (_selectedDateRange != null) {
      filtered =
          filtered.where((n) {
            return n.date.isAfter(
                  _selectedDateRange!.start.subtract(const Duration(days: 1)),
                ) &&
                n.date.isBefore(
                  _selectedDateRange!.end.add(const Duration(days: 1)),
                );
          }).toList();
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _filteredNews = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Noticias y Alertas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
          _allNews.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Widget modular de filtro
                  NewsFilterWidget(
                    selectedTag: _selectedTag,
                    tags: _tags,
                    onTagChanged: (value) {
                      setState(() {
                        _selectedTag = value;
                        _applyFilters();
                      });
                    },
                    selectedDateRange: _selectedDateRange,
                    onDateRangeChanged: (range) {
                      setState(() {
                        _selectedDateRange = range;
                        _applyFilters();
                      });
                    },
                  ),
                  Expanded(
                    child:
                        _filteredNews.isEmpty
                            ? const Center(
                              child: Text(
                                "No hay noticias para estos filtros.",
                              ),
                            )
                            : ListView.builder(
                              itemCount: _filteredNews.length,
                              itemBuilder:
                                  (context, index) =>
                                      NewsCard(news: _filteredNews[index]),
                            ),
                  ),
                ],
              ),
    );
  }
}
