import "package:ciudadano/features/home/comunity/data/models/cam_feed.dart";
import "dart:convert";
import "package:flutter/services.dart";

abstract class CamFeedLocalDatasource {
  Future<List<CamFeedModel>> getCamaras();
}

class CamFeedLocalDatasourceImpl implements CamFeedLocalDatasource {
  final String assetPath;
  CamFeedLocalDatasourceImpl({
    this.assetPath = "assets/data/surveillance.json",
  });

  @override
  Future<List<CamFeedModel>> getCamaras() async {
    final raw = await rootBundle.loadString(assetPath);
    final List decoded = json.decode(raw) as List;
    return decoded
        .map((e) => CamFeedModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
