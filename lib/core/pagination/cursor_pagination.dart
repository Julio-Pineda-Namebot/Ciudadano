class CursorPagination<T> {
  final List<T> items;
  final bool hasMore;
  final String? nextCursor;

  CursorPagination({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  factory CursorPagination.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsJson = json["items"] as List;
    final items = itemsJson.map((e) => fromJsonT(e)).toList();

    return CursorPagination<T>(
      items: items,
      nextCursor: json["nextCursor"],
      hasMore: json["nextCursor"] != null,
    );
  }
}
