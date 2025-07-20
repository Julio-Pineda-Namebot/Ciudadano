import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../bloc/notification_bloc.dart";
import "../bloc/notification_event.dart";
import "../bloc/notification_state.dart" as state;
import "../../domain/entities/push_notification.dart";

class NotificationTestPage extends StatelessWidget {
  const NotificationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones Push"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<NotificationBloc, state.NotificationState>(
        listener: (context, notifState) {
          if (notifState is state.NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(notifState.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (notifState is state.NotificationPermissionGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Permisos de notificación concedidos"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (notifState is state.NotificationTokenRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Token registrado: ${notifState.token.substring(0, 20)}...",
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (notifState is state.NotificationReceived &&
              notifState.latestNotification != null) {
            _showNotificationDialog(context, notifState.latestNotification!);
          }
        },
        builder: (context, notifState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(notifState),
                const SizedBox(height: 20),
                _buildActionButtons(context, notifState),
                const SizedBox(height: 20),
                _buildNotificationsList(notifState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(state.NotificationState notifState) {
    String status = "Inicializando...";
    Color statusColor = Colors.orange;
    String? token;

    if (notifState is state.NotificationInitialized) {
      status =
          notifState.permissionsGranted
              ? "Configurado correctamente"
              : "Permisos denegados";
      statusColor = notifState.permissionsGranted ? Colors.green : Colors.red;
      token = notifState.firebaseToken;
    } else if (notifState is state.NotificationError) {
      status = "Error: ${notifState.message}";
      statusColor = Colors.red;
    } else if (notifState is state.NotificationLoading) {
      status = "Cargando...";
      statusColor = Colors.blue;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications, color: statusColor),
                const SizedBox(width: 8),
                Text(
                  "Estado de Notificaciones",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(status),
            if (token != null) ...[
              const SizedBox(height: 8),
              Text(
                "Token: ${token.substring(0, 30)}...",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    state.NotificationState notifState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            context.read<NotificationBloc>().add(
              RequestNotificationPermissions(),
            );
          },
          icon: const Icon(Icons.security),
          label: const Text("Solicitar Permisos"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            context.read<NotificationBloc>().autoRegisterToken();
          },
          icon: const Icon(Icons.app_registration),
          label: const Text("Registrar Token"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            context.read<NotificationBloc>().add(ClearAllNotifications());
          },
          icon: const Icon(Icons.clear_all),
          label: const Text("Limpiar Notificaciones"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(state.NotificationState notifState) {
    if (notifState is state.NotificationReceived ||
        notifState is state.NotificationInitialized) {
      List<PushNotification> notifications = [];

      if (notifState is state.NotificationReceived) {
        notifications = notifState.notifications;
      } else if (notifState is state.NotificationInitialized) {
        notifications = notifState.notifications;
      }

      return Expanded(
        child: Card(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Notificaciones Recibidas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child:
                    notifications.isEmpty
                        ? const Center(
                          child: Text(
                            "No hay notificaciones",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return _buildNotificationTile(
                              context,
                              notification,
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildNotificationTile(
    BuildContext context,
    PushNotification notification,
  ) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.emergency_alert:
        icon = Icons.warning;
        iconColor = Colors.red;
        break;
      case NotificationType.incident_update:
        icon = Icons.info;
        iconColor = Colors.orange;
        break;
      case NotificationType.chat_message:
        icon = Icons.message;
        iconColor = Colors.blue;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.2),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.body),
          Text(
            _formatTime(notification.receivedAt),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing:
          notification.isRead
              ? null
              : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
      onTap: () {
        context.read<NotificationBloc>().add(
          HandleNotificationTap(notification),
        );
      },
    );
  }

  void _showNotificationDialog(
    BuildContext context,
    PushNotification notification,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  notification.type == NotificationType.emergency_alert
                      ? Icons.warning
                      : Icons.notifications,
                  color:
                      notification.type == NotificationType.emergency_alert
                          ? Colors.red
                          : Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(notification.title)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.body),
                if (notification.data.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "Datos adicionales:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...notification.data.entries.map(
                    (entry) => Text("${entry.key}: ${entry.value}"),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cerrar"),
              ),
            ],
          ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Ahora";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h";
    } else {
      return "${difference.inDays}d";
    }
  }
}
