import "package:animations/animations.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/main_navigation.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:ciudadano/features/auth/presentation/pages/login_page.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/widgets/geolocalization_provider.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, _) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeScaleTransition(animation: animation, child: child),
          ),
          (route) => false,
        );
      },
      listenWhen: (previous, current) => current is UnauthenticatedState,
      child: BlocProvider(
        create: (_) => sl<GeolocalizationPermissionCubit>()..askPermission(),
        child: const GeolocalizationProvider(child: MainNavigation()),
      ),
    );
  }
}
