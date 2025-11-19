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
import "package:ciudadano/features/notifications/presentation/bloc/notification_state.dart";
import "package:ciudadano/features/alerts/presentation/bloc/alert_bloc.dart";
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
import "package:ciudadano/common/widgets/network/network_listener.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase de forma más robusta
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      // Si ya existe una app, la usamos
      Firebase.app();
    }
  } on FirebaseException catch (e) {
    if (e.code == "duplicate-app") {
      // Firebase ya está inicializado desde otra fuente (native)
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
  setUpServiceLocator();
  runApp(
    const NetworkListener(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
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

  Widget _buildMainLayoutWithTokenRegistration(BuildContext context) {
    // Registrar el token automáticamente cuando el usuario está logueado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Usuario logueado - registrando token con backend");
      context.read<NotificationBloc>().autoRegisterToken();
    });

    return const MainLayout();
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
          create: (_) {
            final bloc = sl<NotificationBloc>();
            // Agregar un pequeño delay para asegurar que Firebase esté completamente inicializado
            Future.delayed(const Duration(milliseconds: 500), () {
              print("Disparando InitializeNotifications event");
              bloc.add(InitializeNotifications());
            });
            return bloc;
          },
        ),
        BlocProvider(create: (_) => sl<AlertBloc>()),
      ],
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          print("NotificationBloc state changed: ${state.runtimeType}");
          if (state is NotificationInitial) {
            print("Notificación inicial");
          } else if (state is NotificationLoading) {
            print("Notificaciones cargando...");
          } else if (state is NotificationInitialized) {
            print("Notificaciones inicializadas exitosamente");
            print("Permisos: ${state.permissionsGranted}");
            print("Token: ${state.firebaseToken}");

            // Si no hay permisos, solicitarlos automáticamente
            if (!state.permissionsGranted) {
              print("Solicitando permisos de notificación...");
              context.read<NotificationBloc>().add(
                RequestNotificationPermissions(),
              );
            }
          } else if (state is NotificationError) {
            print("Error en notificaciones: ${state.message}");
          } else if (state is NotificationPermissionGranted) {
            print("Permisos de notificación concedidos!");
          } else if (state is NotificationPermissionDenied) {
            print("Permisos de notificación denegados");
          } else if (state is NotificationTokenRegistered) {
            print("🎉 Token registrado exitosamente con el backend!");
            print("Token: ${state.token.substring(0, 20)}...");
          }
        },
        child: NetworkListener(
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
                                  ? _buildMainLayoutWithTokenRegistration(
                                    context,
                                  )
                                  : const LoginPage();
                            },
                          ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
