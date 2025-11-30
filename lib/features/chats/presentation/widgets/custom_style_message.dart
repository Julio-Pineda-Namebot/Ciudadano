import "package:flutter/material.dart";
import "package:flutter_chat_core/flutter_chat_core.dart";

class CustomStyleMessage extends StatelessWidget {
  final TextMessage message;
  final int index;
  final bool isSentByMe;
  final Map<String, User> usersMapped;

  const CustomStyleMessage({
    super.key,
    required this.message,
    required this.index,
    required this.isSentByMe,
    required this.usersMapped,
  });

  @override
  Widget build(BuildContext context) {
    final user = usersMapped[message.authorId];
    final timeFormat = DateFormat("HH:mm");
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar solo para mensajes recibidos
          if (!isSentByMe)
            Container(
              margin: const EdgeInsets.only(right: 12, bottom: 4),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  user?.name?.isNotEmpty == true
                      ? user!.name!.substring(0, 1).toUpperCase()
                      : "?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

          // Contenedor del mensaje
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isSentByMe
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isSentByMe ? 20 : 6),
                  bottomRight: Radius.circular(isSentByMe ? 6 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del usuario (solo para mensajes recibidos)
                  if (!isSentByMe && user?.name?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        user!.name!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                  // Contenido del mensaje
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isSentByMe
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Hora y estado del mensaje
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            timeFormat.format(message.createdAt!.toLocal()),
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  isSentByMe
                                      ? theme.colorScheme.onPrimary.withOpacity(
                                        0.7,
                                      )
                                      : theme.colorScheme.onSurfaceVariant
                                          .withOpacity(0.7),
                            ),
                          ),
                          if (isSentByMe) ...[
                            const SizedBox(width: 4),
                            Icon(
                              _getStatusIcon(message),
                              size: 14,
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.7,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(TextMessage message) {
    if (message.failedAt != null) {
      return Icons.error_outline;
    } else if (message.deliveredAt != null) {
      return Icons.done_all; // Doble check
    } else {
      return Icons.done; // Check simple
    }
  }
}
