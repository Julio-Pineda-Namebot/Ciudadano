import "package:equatable/equatable.dart";

class ChatGroup extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final List<ChatGroupUser> members;

  const ChatGroup({
    required this.id,
    required this.name,
    this.members = const [],
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt, members];
}

class ChatGroupUser extends Equatable {
  final String id;
  final String name;
  final String phone;

  const ChatGroupUser({
    required this.id,
    required this.name,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, name, phone];
}
