import "../../domain/entities/alert.dart";

class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.userId,
    required super.latitude,
    required super.longitude,
    super.address,
    required super.timestamp,
    required super.status,
    super.message,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    // Verificar si la respuesta incluye geolocalization (estructura de envío)
    double latitude, longitude;

    if (json.containsKey("geolocalization")) {
      latitude = double.parse(json["geolocalization"]["latitude"].toString());
      longitude = double.parse(json["geolocalization"]["longitude"].toString());
    } else if (json.containsKey("location_lat") &&
        json.containsKey("location_lon")) {
      // Estructura del backend (respuesta)
      latitude = double.parse(json["location_lat"].toString());
      longitude = double.parse(json["location_lon"].toString());
    } else {
      // Estructura antigua
      latitude = double.parse(json["latitude"].toString());
      longitude = double.parse(json["longitude"].toString());
    }

    // Manejar diferentes campos de timestamp
    DateTime timestamp;
    if (json.containsKey("triggered_at")) {
      timestamp = DateTime.parse(json["triggered_at"]);
    } else if (json.containsKey("created_at")) {
      timestamp = DateTime.parse(json["created_at"]);
    } else {
      timestamp = DateTime.now();
    }

    // Manejar diferentes campos de status
    AlertStatus status;
    if (json.containsKey("active")) {
      status =
          json["active"] == true ? AlertStatus.active : AlertStatus.inactive;
    } else if (json.containsKey("status")) {
      status = _statusFromString(json["status"]);
    } else {
      status = AlertStatus.inactive;
    }

    return AlertModel(
      id: json["id"].toString(),
      userId: json["user_id"].toString(),
      latitude: latitude,
      longitude: longitude,
      address: json["address"],
      timestamp: timestamp,
      status: status,
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "geolocalization": {"latitude": latitude, "longitude": longitude},
      "address": address,
      "message": message,
      "status": _statusToString(status),
    };
  }

  // Método específico para crear alertas (POST)
  Map<String, dynamic> toCreateJson() {
    return {
      "geolocalization": {"latitude": latitude, "longitude": longitude},
    };
  }

  static AlertStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return AlertStatus.active;
      case "inactive":
        return AlertStatus.inactive;
      case "resolved":
        return AlertStatus.resolved;
      default:
        return AlertStatus.inactive;
    }
  }

  static String _statusToString(AlertStatus status) {
    switch (status) {
      case AlertStatus.active:
        return "active";
      case AlertStatus.inactive:
        return "inactive";
      case AlertStatus.resolved:
        return "resolved";
    }
  }
}
