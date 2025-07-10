import "package:ciudadano/features/profile/data/models/user_profile_modal.dart";
import "package:ciudadano/features/profile/data/profile_remote_datasource.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "user_profile_event.dart";
import "user_profile_state.dart";
import "package:logger/logger.dart";

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ProfileRemoteDatasource _datasource = ProfileRemoteDatasource();
  final _logger = Logger();

  UserProfileBloc() : super(const UserProfileState()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdateField>(_onUpdateField);
    on<SaveProfile>(_onSaveProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      final profile = await _datasource.getProfile();
      emit(
        state.copyWith(
          id: profile.id,
          name: "${profile.firstName} ${profile.lastName}",
          dni: profile.dni,
          email: profile.email,
          phone: profile.phone,
          address: profile.address,
        ),
      );
    } catch (e) {
      _logger.e("Error al cargar perfil", error: e);
    }
  }

  void _onUpdateField(UpdateField event, Emitter<UserProfileState> emit) {
    emit(
      state.copyWith(
        name: event.name ?? state.name,
        dni: event.dni ?? state.dni,
        email: event.email ?? state.email,
        phone: event.phone ?? state.phone,
        address: event.address ?? state.address,
        pushNotifications: event.pushNotifications ?? state.pushNotifications,
      ),
    );
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      final names = state.name.split(" ");
      final firstName = names.first;
      final lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

      final updatedProfile = UserProfileModel(
        id: "no-id-needed-or-fetch-it",
        firstName: firstName,
        lastName: lastName,
        dni: state.dni,
        email: state.email,
        phone: state.phone,
        address: state.address,
      );

      await _datasource.updateProfile(updatedProfile);
      _logger.i("Perfil actualizado exitosamente");
    } catch (e) {
      _logger.e("Error al guardar el perfil", error: e);
    }
  }
}
