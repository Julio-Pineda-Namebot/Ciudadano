import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_get_profile_if_authenticated.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();

  @override
  List<Object?> get props => [];
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();

  @override
  List<Object?> get props => [];
}

class AuthenticatedState extends AuthState {
  final AuthProfile authProfile;

  const AuthenticatedState(this.authProfile);

  @override
  List<Object?> get props => [authProfile];
}

class AuthCubit extends Cubit<AuthState> {
  final AuthGetProfileIfAuthenticated _getProfileIfAuthenticated;

  AuthCubit(this._getProfileIfAuthenticated) : super(const AuthLoadingState());

  void checkAuthentication() async {
    emit(const AuthLoadingState());

    final profile = await _getProfileIfAuthenticated();

    if (profile != null) {
      emit(AuthenticatedState(profile));
    } else {
      emit(const UnauthenticatedState());
    }
  }
}
