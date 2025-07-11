import "package:ciudadano/features/sidebar/logout/data/logout_datasource.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class LogoutEvent {}

class LogoutPressed extends LogoutEvent {}

// Estados
abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutDatasource datasource;

  LogoutBloc(this.datasource) : super(LogoutInitial()) {
    on<LogoutPressed>((event, emit) async {
      await datasource.clearToken();
      emit(LogoutSuccess());
    });
  }
}
