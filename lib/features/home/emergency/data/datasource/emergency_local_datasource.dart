import "dart:convert";
import "package:ciudadano/features/home/emergency/data/models/contact_model.dart";
import "package:flutter/services.dart";

abstract class EmergenciaLocalDatasource {
  Future<List<ContactoModel>> cargarContactos();
}

class EmergenciaLocalDatasourceImpl implements EmergenciaLocalDatasource {
  @override
  Future<List<ContactoModel>> cargarContactos() async {
    final String response = await rootBundle.loadString(
      "assets/data/contact.json",
    );
    final List<dynamic> data = json.decode(response);
    return data.map((item) => ContactoModel.fromJson(item)).toList();
  }
}
