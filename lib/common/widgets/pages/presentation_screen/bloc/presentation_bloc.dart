import "package:flutter_bloc/flutter_bloc.dart";
import "package:shared_preferences/shared_preferences.dart";

abstract class PresentationEvent {}

class CheckPresentationEvent extends PresentationEvent {}

class MarkPresentationSeenEvent extends PresentationEvent {}

abstract class PresentationState {}

class PresentationInitial extends PresentationState {}

class PresentationSeen extends PresentationState {}

class PresentationNotSeen extends PresentationState {}

class PresentationBloc extends Bloc<PresentationEvent, PresentationState> {
  PresentationBloc() : super(PresentationInitial()) {
    on<CheckPresentationEvent>(_checkIfSeen);
    on<MarkPresentationSeenEvent>(_markAsSeen);
  }

  Future<void> _checkIfSeen(
    CheckPresentationEvent event,
    Emitter<PresentationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool("hasSeenIntro") ?? false;
    if (hasSeenIntro) {
      emit(PresentationSeen());
    } else {
      emit(PresentationNotSeen());
    }
  }

  Future<void> _markAsSeen(
    MarkPresentationSeenEvent event,
    Emitter<PresentationState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasSeenIntro", true);
    emit(PresentationSeen());
  }
}
