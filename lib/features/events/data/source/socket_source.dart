import "dart:async";

import "package:ciudadano/service_locator.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:latlong2/latlong.dart";
// ignore: library_prefixes
import "package:socket_io_client/socket_io_client.dart" as IO;

class SocketSource {
  late IO.Socket _socket;

  void _sendLocation(LatLng location) {
    if (_socket.connected) {
      _socket.emit("set_location", {
        "latitude": location.latitude,
        "longitude": location.longitude,
      });
    }
  }

  Future<void> connect(LatLng location) async {
    try {
      final completer = Completer<void>();
      final token = await sl<FlutterSecureStorage>().read(key: "auth_token");
      _socket = IO.io(
        "http://192.168.0.5:3000",
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .setPath("/api/socket")
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(20000)
            .setAuth({"token": token})
            .disableAddTrailingSlash()
            .build(),
      );

      _socket.onDisconnect((_) {
        print("Disconnected from socket server");
      });

      _socket.onConnect((_) {
        print("Connected to socket server");
        _sendLocation(location);
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      _socket.onConnectError((data) {
        print("Connection error: $data");
        if (!completer.isCompleted) {
          completer.completeError(Exception("Socket connection error: $data"));
        }
      });

      _socket.onError((data) {
        print("Socket error: $data");
        if (!completer.isCompleted) {
          completer.completeError(Exception("Socket error: $data"));
        }
      });

      await completer.future;
    } catch (e) {
      print("Error connecting to socket server: $e");
      throw Exception("Failed to connect to socket server");
    }
  }

  void subscribeChannel(
    String channel, {
    Function(Map<String, dynamic>)? onData,
  }) {
    print("Connecting to channel: $channel");
    if (_socket.connected) {
      _socket.on(channel, (data) {
        print("Received data on channel $channel: $data");
        if (onData != null) {
          onData(data);
        }
      });
    }
  }

  void disconnectChannel(String channel) {
    if (_socket.connected) {
      _socket.off(channel);
      print("Disconnected from channel $channel");
    }
  }

  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }
}
