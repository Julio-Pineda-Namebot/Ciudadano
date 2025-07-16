import "package:ciudadano/features/home/comunity/domain/entities/cam_feed.dart";
import "package:equatable/equatable.dart";

abstract class CamState extends Equatable {
  const CamState();
  @override
  List<Object?> get props => [];
}

class CamInitial extends CamState {}

class CamLoading extends CamState {}

class CamLoaded extends CamState {
  final List<CamFeed> feeds;
  const CamLoaded(this.feeds);
  @override
  List<Object?> get props => [feeds];
}

class CamError extends CamState {
  final String msg;
  const CamError(this.msg);
  @override
  List<Object?> get props => [msg];
}
