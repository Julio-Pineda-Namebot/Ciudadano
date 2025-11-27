import "package:ciudadano/config/ws/ws_config.dart";
import "package:ciudadano/core/log/pr.dart";
import "package:socket_io_client/socket_io_client.dart" as io;

class SocketIoClient {
  io.Socket? socket;

  void connect({
    String namespace = "",
    Map<String, dynamic> authData = const {},
  }) {
    socket = io.io(
      WsConfig.baseUrl + namespace,
      io.OptionBuilder()
          .setTransports(["websocket"])
          .enableAutoConnect()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setTimeout(20000)
          .setAuth(authData)
          .build(),
    );

    // socket?.connect();

    socket?.onConnect((_) {
      pr("Socket connected to $namespace");
    });

    socket?.onDisconnect((_) {
      pr("Socket disconnected from $namespace");
    });
  }

  void dispose() {
    socket?.dispose();
    socket = null;
  }

  bool get isConnected => socket?.connected ?? false;
}
