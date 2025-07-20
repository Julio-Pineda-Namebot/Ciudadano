import "dart:async";

import "package:ciudadano/common/widgets/layouts/main/main_layout.dart";
import "package:ciudadano/common/widgets/pages/presentation_screen/bloc/presentation_bloc.dart";
import "package:ciudadano/common/widgets/pages/presentation_screen/presentation_screen_page.dart";
import "package:ciudadano/config/theme/app_theme.dart";
import "package:ciudadano/features/auth/presentation/pages/login_page.dart";
import "package:ciudadano/features/chats/presentation/bloc/contacts/chat_contacts_bloc.dart";
import "package:ciudadano/features/chats/presentation/bloc/group_messages/group_messages_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/groups/chat_groups_bloc.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/activity/activity_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/activity/activity_event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_event.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:ciudadano/features/notifications/presentation/bloc/notification_bloc.dart";
import "package:ciudadano/features/notifications/presentation/bloc/notification_event.dart";
import "package:ciudadano/features/sidebar/profile/data/profile_remote_datasource.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_bloc.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_event.dart";
import "package:ciudadano/features/sidebar/logout/bloc/logout_bloc.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_bloc.dart";
import "package:ciudadano/service_locator.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:lottie/lottie.dart";
import "package:splash_master/splash_master.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final secureStorage = sl<FlutterSecureStorage>();
    final profileDatasource = ProfileRemoteDatasource();
    final token = await secureStorage.read(key: "auth_token");

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      await profileDatasource.getProfile();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LogoutBloc>()),
        BlocProvider(
          create:
              (context) => PresentationBloc()..add(CheckPresentationEvent()),
        ),
        BlocProvider(
          create: (context) => sl<LocationCubit>()..loadInitialLocation(),
        ),
        BlocProvider(
          create:
              (context) =>
                  sl<NearbyIncidentsBloc>()..add(LoadNearbyIncidents()),
        ),
        BlocProvider(
          create: (context) => sl<SocketBloc>()..add(ConnectToSocketEvent()),
        ),
        BlocProvider(create: (context) => sl<ChatGroupsBloc>()),
        BlocProvider(
          create:
              (context) =>
                  sl<ChatContactsBloc>()..add(const LoadChatContacts()),
        ),
        BlocProvider(create: (context) => sl<GroupMessagesCubit>()),
        BlocProvider(
          create: (context) => sl<UserProfileBloc>()..add(FetchProfile()),
        ),
        BlocProvider(
          create: (_) => sl<ActividadBloc>()..add(CargarActividades()),
        ),
        BlocProvider(create: (_) => sl<EventoBloc>()..add(CargarEventos())),
        BlocProvider(create: (_) => sl<CamBloc>()..add(CargarCamaras())),
        BlocProvider(create: (_) => sl<RouteBloc>()),
        BlocProvider(
          create: (_) => sl<NotificationBloc>()..add(InitializeNotifications()),
        ),
      ],
      child: MaterialApp(
        title: "Ciudadano",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale("es"), Locale("en")],
        locale: const Locale("es"),
        home: BlocBuilder<PresentationBloc, PresentationState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child:
                  state is PresentationNotSeen
                      ? const PresentationScreenPage()
                      : FutureBuilder(
                        future: _isLoggedIn(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return const LoginPage();
                          }

                          return snapshot.data!
                              ? const MainLayout()
                              : const LoginPage();
                        },
                      ),
            );
          },
        ),
      ),
    );
  }
}
