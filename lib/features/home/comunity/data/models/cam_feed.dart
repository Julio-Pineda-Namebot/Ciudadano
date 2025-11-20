import "package:ciudadano/features/home/comunity/domain/entities/cam_feed.dart";

class CamFeedModel extends CamFeed {
  const CamFeedModel({
    required super.id,
    required super.titulo,
    required super.gifPath,
  });

  factory CamFeedModel.fromJson(Map<String, dynamic> json) => CamFeedModel(
    id: json["id"] as int,
    titulo: json["titulo"] as String,
    gifPath: json["gif"] as String,
  );
}
