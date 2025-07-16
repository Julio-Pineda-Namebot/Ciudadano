import "dart:convert";
import "package:flutter/services.dart";
import "package:ciudadano/features/home/comunity/data/models/event_model.dart";

abstract class EventoLocalDatasource {
  Future<List<EventoModel>> getEventos();
}

class EventoLocalDatasourceImpl implements EventoLocalDatasource {
  final String assetPath;
  EventoLocalDatasourceImpl({this.assetPath = "assets/data/event.json"});

  @override
  Future<List<EventoModel>> getEventos() async {
    final raw = await rootBundle.loadString(assetPath);
    final List decoded = json.decode(raw) as List;
    return decoded
        .map((e) => EventoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
