import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/check_geolocalization_permission_status_use_case.dart";
import "package:ciudadano/features/geolocalization/domain/usecases/request_geolocalization_permission_use_case.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class GeolocalizationPermissionState extends Equatable {
  final LocationStatus? status;

  const GeolocalizationPermissionState({this.status});

  @override
  List<Object?> get props => [status];
}

class GeolocalizationPermissionCubit
    extends Cubit<GeolocalizationPermissionState> {
  final RequestGeolocalizationPermissionUseCase _requestPermissionUseCase;
  final CheckGeolocalizationPermissionStatusUseCase _checkStatusUseCase;

  GeolocalizationPermissionCubit(
    this._requestPermissionUseCase,
    this._checkStatusUseCase,
  ) : super(const GeolocalizationPermissionState());

  Future<void> evaluate() async {
    final status = await _checkStatusUseCase();
    emit(GeolocalizationPermissionState(status: status));
  }

  Future<void> askPermission() async {
    final status = await _requestPermissionUseCase();

    emit(GeolocalizationPermissionState(status: status));
  }
}
