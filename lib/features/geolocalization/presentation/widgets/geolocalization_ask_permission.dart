import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class GeolocalizationAskPermission extends StatefulWidget {
  final Widget child;

  const GeolocalizationAskPermission({super.key, required this.child});

  @override
  State<GeolocalizationAskPermission> createState() =>
      _GeolocalizationAskPermissionState();
}

class _GeolocalizationAskPermissionState
    extends State<GeolocalizationAskPermission> {
  bool hasAskedPermission = false;

  Future<void> _askPermissionIfNeeded() async {
    await BlocProvider.of<GeolocalizationPermissionCubit>(
      context,
    ).askPermission();
    setState(() {
      hasAskedPermission = true;
    });
  }

  @override
  void initState() {
    _askPermissionIfNeeded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      GeolocalizationPermissionCubit,
      GeolocalizationPermissionState
    >(
      listener: (context, state) {
        BlocProvider.of<GetLocationCubit>(context).listenLocation();
      },
      listenWhen:
          (previous, current) => current.status == LocationStatus.granted,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child:
            hasAskedPermission
                ? widget.child
                : const Scaffold(backgroundColor: Colors.black),
      ),
    );
  }
}
