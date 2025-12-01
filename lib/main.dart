import "package:ciudadano/config/theme/app_theme.dart";
import "package:ciudadano/features/app_shell/presentation/pages/splash/splash_page.dart";
import "package:ciudadano/features/auth/presentation/widgets/auth_provider.dart";
import "package:ciudadano/firebase_options.dart";
import "package:ciudadano/service_locator.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:mapbox_maps_flutter/mapbox_maps_flutter.dart";
import "package:splash_master/splash_master.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }
  } on FirebaseException catch (e) {
    if (e.code == "duplicate-app") {
      print("Firebase ya está inicializado desde configuración nativa");
    } else {
      print("Error inicializando Firebase: ${e.message}");
      rethrow;
    }
  } catch (e) {
    print("Error inesperado inicializando Firebase: $e");
    rethrow;
  }

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
    return AuthProvider(
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
    );
  }
}
