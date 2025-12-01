import "package:equatable/equatable.dart";

class PushToken extends Equatable {
  final String token;
  final String platform;
  final DateTime createdAt;
  final bool isActive;

  const PushToken({
    required this.token,
    required this.platform,
    required this.createdAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [token, platform, createdAt, isActive];
}

enum Platform { android, ios, web }
