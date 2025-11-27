import "package:animations/animations.dart";
import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/pages/location_permission_required_page.dart";
import "package:ciudadano/features/geolocalization/presentation/pages/obtaining_location_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:latlong2/latlong.dart";
import "package:provider/provider.dart";

class GeolocalizationProvider extends StatefulWidget {
  final Widget child;

  const GeolocalizationProvider({super.key, required this.child});

  @override
  State<GeolocalizationProvider> createState() =>
      _GeolocalizationProviderState();
}

class _GeolocalizationProviderState extends State<GeolocalizationProvider>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<GeolocalizationPermissionCubit>().evaluate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder:
          (child, animation) =>
              FadeScaleTransition(animation: animation, child: child),
      child: BlocBuilder<
        GeolocalizationPermissionCubit,
        GeolocalizationPermissionState
      >(
        builder: (context, state) {
          if (state.status == null) {
            return const Scaffold(backgroundColor: Colors.black);
          }

          if (state.status == LocationStatus.granted) {
            return BlocProvider(
              create: (_) => sl<GetLocationCubit>()..listenLocation(),
              child: BlocBuilder<GetLocationCubit, GetLocationState>(
                builder: (context, state) {
                  if (state.location != null) {
                    return Provider<CurrentLocation>(
                      create:
                          (_) => CurrentLocation(
                            state.location!.latitude,
                            state.location!.longitude,
                          ),
                      child: widget.child,
                    );
                  }

                  return const ObtainingLocationPage();
                },
              ),
            );
          }

          return const LocationPermissionRequiredPage();
        },
      ),
    );
  }
}

class CurrentLocation extends LatLng {
  const CurrentLocation(super.latitude, super.longitude);
}
