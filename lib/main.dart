import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciudadano/config/theme/styles.dart';
import 'package:splash_master/splash_master.dart';
import 'package:ciudadano/features/auth/presentation/pages/loginscreen.dart';
import 'package:ciudadano/features/main/presentation/bloc/presentation_bloc.dart';
import 'package:ciudadano/features/main/presentation/pages/presentationscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SplashMaster.lottie(
      source: AssetSource('assets/lottie/splash_gif.json'),
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
    return BlocProvider(
      create: (context) => PresentationBloc()..add(CheckPresentationEvent()),
      child: MaterialApp(
        title: 'Ciudadano',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: BlocBuilder<PresentationBloc, PresentationState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: state is PresentationNotSeen ? const PresentationScreen() : const MyLoginPage(),
            );
          },
        ),
      ),
    );
  }
}
