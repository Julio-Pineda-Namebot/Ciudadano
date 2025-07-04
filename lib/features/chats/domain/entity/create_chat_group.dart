abstract class CreateChatGroup {
  final String name;
  final List<String> members;
  final String description;

  const CreateChatGroup({
    required this.name,
    required this.members,
    required this.description,
  });

  Map<String, dynamic> toJson();
}
