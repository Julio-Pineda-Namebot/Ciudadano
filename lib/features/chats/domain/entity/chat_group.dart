abstract class ChatGroup {
  final String id;
  final String name;
  final String description;
  final String code;
  final DateTime createdAt;

  const ChatGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.createdAt,
  });
}
