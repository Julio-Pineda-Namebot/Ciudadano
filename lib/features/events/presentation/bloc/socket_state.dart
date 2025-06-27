part of "socket_bloc.dart";

abstract class SocketState extends Equatable {
  const SocketState();

  @override
  List<Object?> get props => [];
}

class SocketInitial extends SocketState {}

class SocketConnectedState extends SocketState {}

class SocketDisconnectedState extends SocketState {}

class SocketErrorState extends SocketState {
  final String message;

  const SocketErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
