import "package:equatable/equatable.dart";

class ChatContact extends Equatable {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String phone;

  const ChatContact({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, userId, firstName, lastName, phone];
}
