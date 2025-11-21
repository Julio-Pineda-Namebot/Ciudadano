import "package:ciudadano/features/incidents/domain/entities/incident.dart";
import "package:ciudadano/features/sidebar/safe_route/data/models/route_step_model.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:latlong2/latlong.dart";

class RouteRemoteDatasource {
  final Dio _dio = Dio();

  // Radio de evasión en metros (100 metros alrededor de cada incidencia)
  static const double _avoidanceRadius = 100.0;

  RouteRemoteDatasource();

  Future<List<RouteStepModel>> getRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
    List<Incident> incidentsToAvoid,
  ) async {
    try {
      // Si no hay incidencias, obtener ruta directa
      if (incidentsToAvoid.isEmpty) {
        debugPrint("✅ No hay incidencias, obteniendo ruta directa");
        return _getDirectRoute(startLat, startLng, endLat, endLng);
      }

      debugPrint("⚠️ Verificando ${incidentsToAvoid.length} incidencias");

      // Primero obtener ruta directa
      final directRoute = await _getDirectRoute(
        startLat,
        startLng,
        endLat,
        endLng,
      );

      // Verificar si la ruta pasa cerca de alguna incidencia
      final dangerousIncidents = _checkRouteForIncidents(
        directRoute,
        incidentsToAvoid,
      );

      if (dangerousIncidents.isEmpty) {
        debugPrint("✅ Ruta directa no pasa cerca de incidencias");
        return directRoute;
      }

      debugPrint(
        "⚠️ Ruta pasa cerca de ${dangerousIncidents.length} incidencias, buscando alternativa...",
      );

      // Intentar obtener ruta con waypoints que eviten las incidencias
      final safeRoute = await _getRouteAvoidingIncidents(
        startLat,
        startLng,
        endLat,
        endLng,
        dangerousIncidents,
      );

      if (safeRoute != null && safeRoute.isNotEmpty) {
        debugPrint("✅ Ruta alternativa generada");
        return safeRoute;
      }

      // Si no se pudo generar ruta alternativa, devolver la directa con advertencia
      debugPrint("⚠️ No se pudo generar ruta alternativa, usando ruta directa");
      return directRoute;
    } catch (e) {
      debugPrint("❌ Error obteniendo ruta de OSRM: $e");
      return _generateFallbackRoute(startLat, startLng, endLat, endLng);
    }
  }

  Future<List<RouteStepModel>> _getDirectRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final url =
        "https://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat?overview=full&geometries=geojson&steps=true";

    final response = await _dio.get(url);

    if (response.statusCode == 200 && response.data["code"] == "Ok") {
      final routes = response.data["routes"] as List;
      if (routes.isEmpty) {
        return _generateFallbackRoute(startLat, startLng, endLat, endLng);
      }

      final route = routes[0];
      final geometry = route["geometry"]["coordinates"] as List;

      debugPrint("✅ Ruta obtenida con ${geometry.length} puntos");

      return _convertCoordinatesToSteps(geometry);
    } else {
      return _generateFallbackRoute(startLat, startLng, endLat, endLng);
    }
  }

  List<Incident> _checkRouteForIncidents(
    List<RouteStepModel> route,
    List<Incident> incidents,
  ) {
    final Distance distance = const Distance();
    final List<Incident> dangerousIncidents = [];

    for (final incident in incidents) {
      for (final step in route) {
        final stepLocation = LatLng(step.lat, step.lng);
        final distanceToIncident = distance.as(
          LengthUnit.Meter,
          stepLocation,
          incident.location,
        );

        if (distanceToIncident < _avoidanceRadius) {
          dangerousIncidents.add(incident);
          debugPrint(
            "⚠️ Ruta pasa a ${distanceToIncident.toStringAsFixed(1)}m de incidencia en (${incident.location.latitude}, ${incident.location.longitude})",
          );
          break; // Solo agregar una vez por incidencia
        }
      }
    }

    return dangerousIncidents;
  }

  Future<List<RouteStepModel>?> _getRouteAvoidingIncidents(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
    List<Incident> incidents,
  ) async {
    // Generar waypoints que rodeen las incidencias
    final waypoints = _generateAvoidanceWaypoints(
      LatLng(startLat, startLng),
      LatLng(endLat, endLng),
      incidents,
    );

    if (waypoints.isEmpty) {
      return null;
    }

    // Construir URL con waypoints
    final coordinates = <String>[
      "$startLng,$startLat",
      ...waypoints.map((w) => "${w.longitude},${w.latitude}"),
      "$endLng,$endLat",
    ];

    final url =
        'https://router.project-osrm.org/route/v1/driving/${coordinates.join(';')}?overview=full&geometries=geojson&steps=true';

    debugPrint(
      "🔄 Intentando ruta con ${waypoints.length} waypoints de evasión",
    );

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data["code"] == "Ok") {
        final routes = response.data["routes"] as List;
        if (routes.isEmpty) {
          return null;
        }

        final route = routes[0];
        final geometry = route["geometry"]["coordinates"] as List;

        return _convertCoordinatesToSteps(geometry);
      }
    } catch (e) {
      debugPrint("❌ Error obteniendo ruta con waypoints: $e");
    }

    return null;
  }

  List<LatLng> _generateAvoidanceWaypoints(
    LatLng start,
    LatLng end,
    List<Incident> incidents,
  ) {
    final Distance distance = const Distance();
    final List<LatLng> waypoints = [];

    // Por cada incidencia, generar un waypoint que la rodee
    for (final incident in incidents) {
      // Calcular la posición del incidente relativa a la línea start-end
      final bearing = distance.bearing(start, end);

      // Generar punto de desvío perpendicular a 200 metros
      final avoidanceBearing = (bearing + 90) % 360; // Perpendicular
      final waypointOffset = distance.offset(
        incident.location,
        200.0, // 200 metros de desvío
        avoidanceBearing,
      );

      waypoints.add(waypointOffset);
      debugPrint(
        "📍 Waypoint de evasión: (${waypointOffset.latitude}, ${waypointOffset.longitude})",
      );
    }

    return waypoints;
  }

  List<RouteStepModel> _convertCoordinatesToSteps(List geometry) {
    final steps = <RouteStepModel>[];

    for (int i = 0; i < geometry.length; i++) {
      final coord = geometry[i];
      steps.add(
        RouteStepModel(
          instruction:
              i == 0
                  ? "Inicio del recorrido"
                  : i == geometry.length - 1
                  ? "Llegaste a tu destino"
                  : "Continúa recto",
          lat: coord[1].toDouble(),
          lng: coord[0].toDouble(),
        ),
      );
    }

    return steps;
  }

  List<RouteStepModel> _generateFallbackRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    debugPrint("⚠️ Usando ruta de respaldo (línea recta)");
    final List<RouteStepModel> steps = [];
    const int numberOfPoints = 20;

    for (int i = 0; i <= numberOfPoints; i++) {
      final double t = i / numberOfPoints;
      final double lat = startLat + (endLat - startLat) * t;
      final double lng = startLng + (endLng - startLng) * t;

      String instruction = "Continúa recto";
      if (i == 0) {
        instruction = "Inicio del recorrido";
      } else if (i == numberOfPoints) {
        instruction = "Llegaste a tu destino";
      }

      steps.add(RouteStepModel(instruction: instruction, lat: lat, lng: lng));
    }

    return steps;
  }
}
