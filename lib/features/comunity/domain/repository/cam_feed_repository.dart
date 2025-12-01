import "package:ciudadano/features/comunity/domain/entities/cam_feed.dart";

abstract class CamFeedRepository {
  Future<List<CamFeed>> obtenerCamaras();
}
