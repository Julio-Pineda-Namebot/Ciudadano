import "package:ciudadano/features/comunity/domain/entities/cam_feed.dart";
import "package:ciudadano/features/comunity/domain/repository/cam_feed_repository.dart";

class GetCamFeeds {
  final CamFeedRepository repo;
  GetCamFeeds(this.repo);
  Future<List<CamFeed>> call() => repo.obtenerCamaras();
}
