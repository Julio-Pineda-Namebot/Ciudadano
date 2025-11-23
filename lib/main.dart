import "package:ciudadano/config/theme/app_theme.dart";
import "package:ciudadano/features/app_shell/presentation/pages/splash/splash_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:splash_master/splash_master.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SplashMaster.initialize();
  await setUpServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
