import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciudadano/config/theme/styles.dart';
import 'package:ciudadano/features/main/presentation/pages/loginscreen.dart';
import 'package:ciudadano/features/main/presentation/bloc/presentation_bloc.dart';
import 'package:ciudadano/features/main/presentation/pages/presentationscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
            if (state is PresentationNotSeen) {
              return const PresentationScreen();
            } else {
              return const MyLoginPage();
            }
          },
        ),
      ),
    );
  }
}
