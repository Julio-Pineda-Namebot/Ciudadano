import "dart:convert";
import "package:flutter/services.dart";
import "package:ciudadano/features/emergency/data/models/help_centers_model.dart";

abstract class CentrosLocalDatasource {
  Future<List<CentroModel>> cargarCentros();
}

class CentrosLocalDatasourceImpl implements CentrosLocalDatasource {
  @override
  Future<List<CentroModel>> cargarCentros() async {
    final String response = await rootBundle.loadString(
      "assets/data/help_center.json",
    );
    final List<dynamic> data = json.decode(response);
    return data.map((e) => CentroModel.fromJson(e)).toList();
  }
}