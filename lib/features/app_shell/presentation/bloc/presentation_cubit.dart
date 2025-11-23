import "package:ciudadano/service_locator.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shared_preferences/shared_preferences.dart";

abstract class PresentationState {}

class PresentationInitial extends PresentationState {}

class PresentationSeen extends PresentationState {}

class PresentationNotSeen extends PresentationState {}

class PresentationCubit extends Cubit<PresentationState> {
  PresentationCubit() : super(PresentationInitial());

  void checkIfPresentationHasSeen() {
    final prefs = sl<SharedPreferences>();
    final hasSeenIntro = prefs.getBool("hasSeenIntro") ?? false;
    if (hasSeenIntro) {
      emit(PresentationSeen());
    } else {
      emit(PresentationNotSeen());
    }
  }

  void markAsSeen() async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool("hasSeenIntro", true);
    emit(PresentationSeen());
  }
}
