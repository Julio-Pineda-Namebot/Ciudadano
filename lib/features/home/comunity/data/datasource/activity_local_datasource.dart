import "package:ciudadano/features/home/comunity/data/models/activity_model.dart";
import "dart:convert";
import "package:flutter/services.dart";

abstract class ActividadLocalDatasource {
  Future<List<ActividadModel>> getActividades();
}

class ActividadLocalDatasourceImpl implements ActividadLocalDatasource {
  final String assetPath;
  ActividadLocalDatasourceImpl({this.assetPath = "assets/data/activity.json"});

  @override
  Future<List<ActividadModel>> getActividades() async {
    final rawJson = await rootBundle.loadString(assetPath);
    final List<dynamic> decoded = json.decode(rawJson) as List<dynamic>;
    return decoded
        .map((e) => ActividadModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
