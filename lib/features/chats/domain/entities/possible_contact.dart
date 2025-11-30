import "package:equatable/equatable.dart";

class PossibleContact extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String phone;

  const PossibleContact({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  List<Object?> get props => [userId, firstName, lastName, phone];
}
