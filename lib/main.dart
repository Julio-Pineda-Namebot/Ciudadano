import "package:ciudadano/common/widgets/pages/presentation_screen/bloc/presentation_bloc.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:ciudadano/config/theme/app_theme.dart";
import "package:splash_master/splash_master.dart";
import "package:ciudadano/features/auth/presentation/pages/login_page.dart";
import "package:ciudadano/common/widgets/pages/presentation_screen/presentation_screen_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
  setUpServiceLocator();
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SplashMaster.lottie(
      source: AssetSource("assets/lottie/splash_gif.json"),
      lottieConfig: LottieConfig(
        repeat: false,
        animate: true,
        width: screenWidth * 0.5,
        height: screenHeight * 0.3,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        frameRate: FrameRate.max,
        errorBuilder: (context, error, stackTrace) {
          return const Text("Error al cargar la animación");
        },
      ),
      backGroundColor: Colors.black,
      nextScreen: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => PresentationBloc()..add(CheckPresentationEvent()),
        ),
        BlocProvider(create: (context) => sl<LocationCubit>()),
        BlocProvider(create: (context) => sl<NearbyIncidentsBloc>()),
        BlocProvider(create: (context) => sl<SocketBloc>()),
      ],
      child: MaterialApp(
        title: "Ciudadano",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: BlocBuilder<PresentationBloc, PresentationState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  state is PresentationNotSeen
                      ? const PresentationScreenPage()
                      : const LoginPage(),
            );
          },
        ),
      ),
    );
  }
}
