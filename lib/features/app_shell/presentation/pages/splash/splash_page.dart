import "package:ciudadano/features/app_shell/presentation/pages/MY_app.dart";
import "package:flutter/material.dart";
import "package:splash_master/splash_master.dart";
import "package:lottie/lottie.dart";

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMaster.lottie(
      source: AssetSource("assets/lottie/splash_screen.json"),
      lottieConfig: LottieConfig(
        repeat: false,
        animate: true,
        width: 250,
        aspectRatio: 1.0,
        fit: BoxFit.contain,
        overrideBoxFit: false,
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
