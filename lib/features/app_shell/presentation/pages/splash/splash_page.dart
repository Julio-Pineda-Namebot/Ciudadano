import "package:ciudadano/features/app_shell/presentation/pages/present/redirect_presentation_screen_page.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:splash_master/splash_master.dart";

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
      customNavigation:
          () => Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder:
                  (_, __, ___) => const RedirectPresentationScreenPage(),
              transitionsBuilder: (_, animation, __, child) {
                final curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                );

                return FadeTransition(
                  opacity: animation,
                  child: Transform.scale(
                    scale: 0.9 + (curved.value * 0.1),
                    child: child,
                  ),
                );
              },
            ),
          ),
    );
  }
}
