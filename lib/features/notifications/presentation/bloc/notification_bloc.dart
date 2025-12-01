import "dart:async";
import "dart:io";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../domain/entities/push_notification.dart";
import "../../domain/usecases/initialize_notifications_use_case.dart";
import "../../domain/usecases/register_push_token_use_case.dart";
import "../../domain/usecases/request_notification_permissions_use_case.dart";
import "../../domain/usecases/listen_to_notifications_use_case.dart";
import "../../domain/repository/notification_repository.dart";
import "notification_event.dart";
import "notification_state.dart" as state;

class NotificationBloc
    extends Bloc<NotificationEvent, state.NotificationState> {
  final InitializeNotificationsUseCase initializeNotificationsUseCase;
  final RegisterPushTokenUseCase registerPushTokenUseCase;
  final RequestNotificationPermissionsUseCase
  requestNotificationPermissionsUseCase;
  final ListenToNotificationsUseCase listenToNotificationsUseCase;
  final NotificationRepository notificationRepository;

  final List<PushNotification> _notifications = [];
  StreamSubscription<PushNotification>? _foregroundSubscription;
  StreamSubscription<PushNotification>? _openedAppSubscription;

  NotificationBloc({
    required this.initializeNotificationsUseCase,
    required this.registerPushTokenUseCase,
    required this.requestNotificationPermissionsUseCase,
    required this.listenToNotificationsUseCase,
    required this.notificationRepository,
  }) : super(state.NotificationInitial()) {
    on<InitializeNotifications>(_onInitializeNotifications);
    on<RequestNotificationPermissions>(_onRequestNotificationPermissions);
    on<RegisterPushToken>(_onRegisterPushToken);
    on<UnregisterPushToken>(_onUnregisterPushToken);
    on<NotificationReceived>(_onNotificationReceived);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<HandleNotificationTap>(_onHandleNotificationTap);
  }

  Future<void> _onInitializeNotifications(
    InitializeNotifications event,
    Emitter<state.NotificationState> emit,
  ) async {
    emit(state.NotificationLoading());

    try {
      // Inicializar Firebase
      final initResult = await initializeNotificationsUseCase();
      if (initResult.isLeft()) {
        emit(
          state.NotificationError(
            initResult.fold((l) => l, (r) => "Unknown error"),
          ),
        );
        return;
      }

      // Verificar permisos
      final permissionsGranted =
          await notificationRepository.areNotificationsEnabled();

      // Obtener token si hay permisos
      String? firebaseToken;
      if (permissionsGranted) {
        final tokenResult = await notificationRepository.getFirebaseToken();
        tokenResult.fold(
          (error) => print("Error getting token: $error"),
          (token) => firebaseToken = token,
        );
      }

      // Configurar listeners
      _setupNotificationListeners();

      // Verificar notificación inicial (app abierta desde notificación)
      final initialNotification =
          await listenToNotificationsUseCase.getInitialNotification();
      if (initialNotification != null) {
        _notifications.add(initialNotification);
        add(HandleNotificationTap(initialNotification));
      }

      emit(
        state.NotificationInitialized(
          notifications: List.from(_notifications),
          permissionsGranted: permissionsGranted,
          firebaseToken: firebaseToken,
        ),
      );
    } catch (e) {
      emit(state.NotificationError("Error initializing notifications: $e"));
    }
  }

  Future<void> _onRequestNotificationPermissions(
    RequestNotificationPermissions event,
    Emitter<state.NotificationState> emit,
  ) async {
    emit(state.NotificationLoading());

    final result = await requestNotificationPermissionsUseCase();
    result.fold((error) => emit(state.NotificationError(error)), (granted) {
      if (granted) {
        emit(state.NotificationPermissionGranted());
        // Después de obtener permisos, intentar obtener el token
        add(InitializeNotifications());
      } else {
        emit(state.NotificationPermissionDenied());
      }
    });
  }

  Future<void> _onRegisterPushToken(
    RegisterPushToken event,
    Emitter<state.NotificationState> emit,
  ) async {
    print(
      "🚀 Registrando token: ${event.token.substring(0, 20)}... en plataforma: ${event.platform}",
    );

    final result = await registerPushTokenUseCase(event.token, event.platform);
    result.fold(
      (error) {
        print("❌ Error registrando token: $error");
        emit(state.NotificationError(error));
      },
      (success) {
        if (success) {
          print("✅ Token registrado exitosamente con el backend");
          emit(state.NotificationTokenRegistered(event.token));
        } else {
          print("❌ Falló el registro del token");
          emit(const state.NotificationError("Failed to register token"));
        }
      },
    );
  }

  Future<void> _onUnregisterPushToken(
    UnregisterPushToken event,
    Emitter<state.NotificationState> emit,
  ) async {
    final tokenResult = await notificationRepository.getFirebaseToken();
    tokenResult.fold((error) => emit(state.NotificationError(error)), (
      token,
    ) async {
      final unregisterResult = await notificationRepository.unregisterPushToken(
        token,
      );
      unregisterResult.fold((error) => emit(state.NotificationError(error)), (
        success,
      ) {
        if (success) {
          emit(state.NotificationTokenUnregistered());
        } else {
          emit(const state.NotificationError("Failed to unregister token"));
        }
      });
    });
  }

  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<state.NotificationState> emit,
  ) async {
    _notifications.insert(0, event.notification);
    emit(
      state.NotificationReceived(
        notifications: List.from(_notifications),
        latestNotification: event.notification,
      ),
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<state.NotificationState> emit,
  ) async {
    final index = _notifications.indexWhere(
      (n) => n.id == event.notificationId,
    );
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      emit(
        state.NotificationReceived(notifications: List.from(_notifications)),
      );
    }
  }

  Future<void> _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<state.NotificationState> emit,
  ) async {
    _notifications.clear();
    emit(const state.NotificationReceived(notifications: []));
  }

  Future<void> _onHandleNotificationTap(
    HandleNotificationTap event,
    Emitter<state.NotificationState> emit,
  ) async {
    // Marcar como leída
    add(MarkNotificationAsRead(event.notification.id));

    // Manejar navegación según el tipo de notificación
    switch (event.notification.type) {
      case NotificationType.emergency_alert:
        // Navegar a mapa o detalles de alerta
        print("Handling emergency alert: ${event.notification.data}");
        break;
      case NotificationType.incident_update:
        // Navegar a incidentes
        print("Handling incident update: ${event.notification.data}");
        break;
      case NotificationType.chat_message:
        // Navegar a chat
        print("Handling chat message: ${event.notification.data}");
        break;
      default:
        print("Handling general notification: ${event.notification.data}");
    }
  }

  void _setupNotificationListeners() {
    // Escuchar notificaciones en primer plano
    _foregroundSubscription = listenToNotificationsUseCase
        .getForegroundNotifications()
        .listen((notification) {
          add(NotificationReceived(notification));
        });

    // Escuchar cuando la app se abre desde una notificación
    _openedAppSubscription = listenToNotificationsUseCase
        .getNotificationOpenedApp()
        .listen((notification) {
          add(NotificationReceived(notification));
          add(HandleNotificationTap(notification));
        });
  }

  /// Método para registrar automáticamente el token después del login
  Future<void> autoRegisterToken() async {
    try {
      print("🔥 autoRegisterToken: Iniciando registro automático de token");

      final permissionsGranted =
          await notificationRepository.areNotificationsEnabled();

      print("🔥 autoRegisterToken: Permisos habilitados: $permissionsGranted");

      if (!permissionsGranted) {
        print("🔥 autoRegisterToken: Permisos no concedidos, solicitando...");
        // Solicitar permisos si no están concedidos
        add(RequestNotificationPermissions());
        return;
      }

      print("🔥 autoRegisterToken: Obteniendo token de Firebase...");
      final tokenResult = await notificationRepository.getFirebaseToken();
      tokenResult.fold(
        (error) {
          print("🔥 autoRegisterToken: Error obteniendo token: $error");
        },
        (token) {
          print(
            "🔥 autoRegisterToken: Token obtenido: ${token.substring(0, 20)}...",
          );
          final platform = Platform.isAndroid ? "android" : "ios";
          print(
            "🔥 autoRegisterToken: Registrando token con plataforma: $platform",
          );
          add(RegisterPushToken(token: token, platform: platform));
        },
      );
    } catch (e) {
      print("🔥 autoRegisterToken: Error auto-registering token: $e");
    }
  }

  @override
  Future<void> close() {
    _foregroundSubscription?.cancel();
    _openedAppSubscription?.cancel();
    return super.close();
  }
}
