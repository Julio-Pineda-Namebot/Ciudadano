import "package:ciudadano/features/home/comunity/domain/entities/cam_feed.dart";

abstract class CamFeedRepository {
  Future<List<CamFeed>> obtenerCamaras();
}
