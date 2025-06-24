abstract class UserProfileEvent {}

class FetchProfile extends UserProfileEvent {}
class SaveProfile extends UserProfileEvent {}

class UpdateField extends UserProfileEvent {
  final String? name;
  final String? dni;
  final String? email;
  final String? phone;
  final String? address;
  final bool? pushNotifications;

  UpdateField({
    this.name,
    this.dni,
    this.email,
    this.phone,
    this.address,
    this.pushNotifications,
  });
}

