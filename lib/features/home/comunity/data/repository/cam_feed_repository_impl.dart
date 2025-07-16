import "package:ciudadano/features/home/comunity/data/datasource/cam_feed_local_datasource.dart";
import "package:ciudadano/features/home/comunity/domain/entities/cam_feed.dart";
import "package:ciudadano/features/home/comunity/domain/repository/cam_feed_repository.dart";

class CamFeedRepositoryImpl implements CamFeedRepository {
  final CamFeedLocalDatasource datasource;
  CamFeedRepositoryImpl({required this.datasource});

  List<CamFeed>? _cache;

  @override
  Future<List<CamFeed>> obtenerCamaras() async {
    _cache ??= await datasource.getCamaras();
    return _cache!;
  }
}
