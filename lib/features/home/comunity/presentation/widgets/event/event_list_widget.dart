import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_state.dart";
import "package:ciudadano/features/home/comunity/presentation/widgets/event/event_card.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class EventoListWidget extends StatelessWidget {
  const EventoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventoBloc, EventoState>(
      builder: (context, state) {
        if (state is EventoLoading || state is EventoInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is EventoError) {
          return Center(child: Text(state.msg));
        }
        final eventos = (state as EventoLoaded).eventos;
        if (eventos.isEmpty) {
          return const Center(child: Text("Sin eventos"));
        }
        return ListView.builder(
          itemCount: eventos.length,
          itemBuilder: (_, i) => EventoCard(evento: eventos[i]),
        );
      },
    );
  }
}
