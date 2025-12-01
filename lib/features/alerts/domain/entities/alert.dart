class Alert {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime timestamp;
  final AlertStatus status;
  final String? message;

  const Alert({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.timestamp,
    required this.status,
    this.message,
  });

  Alert copyWith({
    String? id,
    String? userId,
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
    AlertStatus? status,
    String? message,
  }) {
    return Alert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

enum AlertStatus { active, inactive, resolved }
