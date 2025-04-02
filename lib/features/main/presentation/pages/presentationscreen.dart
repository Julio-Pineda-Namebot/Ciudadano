import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ciudadano/features/main/presentation/bloc/presentation_bloc.dart';
import 'package:ciudadano/features/main/presentation/pages/loginscreen.dart';

class PresentationScreen extends StatelessWidget {
  const PresentationScreen({super.key});

  void _onIntroEnd(BuildContext context) {
    context.read<PresentationBloc>().add(MarkPresentationSeenEvent());

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MyLoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.white);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0,fontWeight: FontWeight.w700, color: Colors.white),
      bodyTextStyle: bodyStyle,
      titlePadding: EdgeInsets.all(5.0),
      imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.all(1),
      imageAlignment: Alignment.bottomCenter,
    );
    
    return SafeArea(
      child: IntroductionScreen(
        globalBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        pages: [
          PageViewModel(
            title: "¡Bienvenido a Ciudadano!",
            body: "Tu app para estar siempre alerta y protegido en tu comunidad.",
            image: Center(
              child: Image.asset('assets/splash.png', width: 350.0),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Reporta incidentes en tiempo real",
            body: "Informa sobre situaciones de riesgo y ayuda a mejorar la seguridad de tu comunidad.",
            image: Center(
              child: Lottie.asset('assets/lottie/splash_present_1.json', 
              width: 350.0,
              height: 350.0
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Alertas y notificaciones inmediatas",
            body: "Recibe avisos sobre emergencias cercanas y mantente informado en todo momento.",
            image: Center(
              child: Lottie.asset(
                'assets/lottie/splash_present_2.json',
                width: 350.0,
                height: 350.0,
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Conéctate con tu comunidad",
            body: "Comunícate con vecinos y autoridades para actuar en conjunto ante cualquier situación.",
            image: Center(
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              child: Center( 
                  child: Lottie.asset(
                  'assets/lottie/splash_present_3.json',
                  width: 250.0,
                  height: 250.0,
                  ),
                ),
              ),
            ),
            decoration: pageDecoration,
          ),
        ],
        showSkipButton: true,
        skip: const Text(
          "Saltar",
          style: TextStyle(color: Colors.white),
        ),
        next: const Icon(Icons.arrow_forward, color: Colors.white),
        done: const Text(
          "Listo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size(10, 10),
          color: Colors.white54,
          activeSize: const Size(22, 10),
          activeColor: Colors.white,
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        onDone: () => _onIntroEnd(context),
        curve: Curves.easeInOut,
      ),
    );
  }
}
