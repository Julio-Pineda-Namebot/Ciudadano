import "package:ciudadano/features/chats/domain/entities/possible_contact.dart";

class PossibleContactModel extends PossibleContact {
  const PossibleContactModel({
    required super.userId,
    required super.firstName,
    required super.lastName,
    required super.phone,
  });

  factory PossibleContactModel.fromJson(Map<String, dynamic> json) {
    return PossibleContactModel(
      userId: json["id"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      phone: json["phone"] as String,
    );
  }
}
