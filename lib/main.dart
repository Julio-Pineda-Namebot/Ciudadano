import "package:ciudadano/config/theme/app_theme.dart";
import "package:ciudadano/features/app_shell/presentation/pages/splash/splash_page.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:ciudadano/features/geolocalization/presentation/widgets/geolocalization_lifecyle_reveal.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:splash_master/splash_master.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SplashMaster.initialize();
  await dotenv.load(fileName: ".env");

  MapboxOptions.setAccessToken(dotenv.env["MAPBOX_ACCESS_TOKEN"] ?? "");
  await setUpServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GeolocalizationPermissionCubit>()),
        BlocProvider(create: (_) => sl<GetLocationCubit>()),
      ],
      child: GeolocalizationLifecyleReveal(
        child: MaterialApp(
          title: "Ciudadano",
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale("es"), Locale("en")],
          locale: const Locale("es"),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
