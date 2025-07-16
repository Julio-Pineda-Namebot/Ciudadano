class News {
  final int id;
  final String title;
  final String summary;
  final String content;
  final String image;
  final DateTime date;
  final String tag;

  const News({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.image,
    required this.date,
    required this.tag,
  });
}