import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";

class NearbyIncidentsMap extends HookWidget {
  const NearbyIncidentsMap({super.key});

  @override
  Widget build(BuildContext context) {
    final mapboxMapRef = useRef<MapboxMap?>(null);

    final locationState = useBlocBuilder(
      BlocProvider.of<GetLocationCubit>(context),
    );

    useEffect(() {
      if (locationState.location != null) {
        mapboxMapRef.value?.setCamera(
          CameraOptions(
            zoom: 15,
            center: Point(
              coordinates: Position(
                locationState.location!.longitude,
                locationState.location!.latitude,
              ),
            ),
          ),
        );
      }
      return null;
    }, [locationState.location, mapboxMapRef.value]);

    return MapWidget(
      onMapCreated: (controller) {
        mapboxMapRef.value = controller;
        controller.logo.updateSettings(LogoSettings(enabled: false));
        controller.attribution.updateSettings(
          AttributionSettings(enabled: false),
        );
        controller.location.updateSettings(
          LocationComponentSettings(
            locationPuck: LocationPuck(
              locationPuck3D: LocationPuck3D(
                modelUri:
                    "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
              ),
            ),
          ),
        );
      },
    );
  }
}
