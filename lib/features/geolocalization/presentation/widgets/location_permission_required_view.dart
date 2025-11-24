import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:geolocator/geolocator.dart";
import "package:hooked_bloc/hooked_bloc.dart";

class LocationPermissionRequiredView extends HookWidget {
  const LocationPermissionRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = useBlocBuilder(
      BlocProvider.of<GeolocalizationPermissionCubit>(context),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(state.status),
            const SizedBox(height: 24),
            _buildTitle(state.status),
            const SizedBox(height: 16),
            _buildDescription(state.status),
            const SizedBox(height: 32),
            _buildActionButton(context, state.status),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(LocationStatus? status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case LocationStatus.denied:
      case LocationStatus.permanentlyDenied:
        iconData = Icons.location_off_rounded;
        iconColor = Colors.red;
        break;
      case LocationStatus.gpsDisabled:
        iconData = Icons.gps_off_rounded;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.location_on_rounded;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 80, color: iconColor),
    );
  }

  Widget _buildTitle(LocationStatus? status) {
    String title;

    switch (status) {
      case LocationStatus.denied:
        title = "Permiso de ubicación requerido";
        break;
      case LocationStatus.permanentlyDenied:
        title = "Permiso de ubicación denegado";
        break;
      case LocationStatus.gpsDisabled:
        title = "GPS desactivado";
        break;
      default:
        title = "Ubicación requerida";
    }

    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(LocationStatus? status) {
    String description;

    switch (status) {
      case LocationStatus.denied:
        description =
            "Esta aplicación requiere acceso a tu ubicación para funcionar correctamente. Por favor, concede el permiso de ubicación.";
        break;
      case LocationStatus.permanentlyDenied:
        description =
            "El permiso de ubicación ha sido denegado permanentemente. Por favor, ve a la configuración de la aplicación y activa el permiso de ubicación manualmente.";
        break;
      case LocationStatus.gpsDisabled:
        description =
            "El GPS está desactivado en tu dispositivo. Por favor, activa el GPS en la configuración de tu dispositivo para continuar.";
        break;
      default:
        description =
            "Esta aplicación necesita acceso a tu ubicación para brindarte la mejor experiencia. Por favor, concede el permiso de ubicación.";
    }

    return Text(
      description,
      style: const TextStyle(fontSize: 16, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(BuildContext context, LocationStatus? status) {
    final cubit = context.read<GeolocalizationPermissionCubit>();

    switch (status) {
      case LocationStatus.denied:
        return ElevatedButton.icon(
          onPressed: () => cubit.askPermission(),
          icon: const Icon(Icons.location_on),
          label: const Text("Conceder permiso"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        );

      case LocationStatus.permanentlyDenied:
        return Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Geolocator.openAppSettings();
              },
              icon: const Icon(Icons.settings),
              label: const Text("Abrir configuración"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => cubit.evaluate(),
              child: const Text("Verificar nuevamente"),
            ),
          ],
        );

      case LocationStatus.gpsDisabled:
        return Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              icon: const Icon(Icons.gps_fixed),
              label: const Text("Activar GPS"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => cubit.evaluate(),
              child: const Text("Verificar nuevamente"),
            ),
          ],
        );

      default:
        return ElevatedButton.icon(
          onPressed: () => cubit.askPermission(),
          icon: const Icon(Icons.location_on),
          label: const Text("Solicitar permiso"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        );
    }
  }
}
