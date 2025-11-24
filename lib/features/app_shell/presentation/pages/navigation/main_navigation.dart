import "package:ciudadano/features/app_shell/presentation/pages/home/home_page.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_bottom_navigation_bar.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_header.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_sidebar.dart";
import "package:ciudadano/features/geolocalization/presentation/widgets/location_permission_required_view.dart";
import "package:ciudadano/features/geolocalization/domain/entities/location_status.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";

class MainNavigation extends HookWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentNavigationBarIndex = useState(0);
    final geolocalizationPermissionCubit =
        BlocProvider.of<GeolocalizationPermissionCubit>(context);
    final geolocalizationPermissionState = useBlocBuilder(
      geolocalizationPermissionCubit,
    );

    final isLocationGranted =
        geolocalizationPermissionState.status == LocationStatus.granted;

    return Scaffold(
      appBar: const AppHeader(),
      drawer: isLocationGranted ? const AppSidebar() : null,
      body:
          isLocationGranted
              ? IndexedStack(
                index: currentNavigationBarIndex.value,
                children: const [
                  HomePage(),
                  Center(child: Text("Search Page")),
                  Center(child: Text("Reports Page")),
                  Center(child: Text("Profile Page")),
                ],
              )
              : const LocationPermissionRequiredView(),
      bottomNavigationBar:
          isLocationGranted
              ? AppBottomNavigationBar(
                currentIndex: currentNavigationBarIndex.value,
                onTap: (value) => currentNavigationBarIndex.value = value,
              )
              : null,
    );
  }
}
