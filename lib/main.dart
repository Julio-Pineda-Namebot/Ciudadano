import "package:ciudadano/config/theme/app_theme.dart";
import "package:ciudadano/features/app_shell/presentation/bloc/presentation_cubit.dart";
import "package:ciudadano/features/app_shell/presentation/pages/present/presentation_screen_page.dart";
import "package:ciudadano/features/auth/presentation/pages/redirect_login_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      home: BlocProvider(
        create:
            (context) => sl<PresentationCubit>()..checkIfPresentationHasSeen(),
        child: BlocBuilder<PresentationCubit, PresentationState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child:
                  state is PresentationNotSeen
                      ? const PresentationScreenPage()
                      : const RedirectLoginPage(),
            );
          },
        ),
      ),
    );
  }
}
