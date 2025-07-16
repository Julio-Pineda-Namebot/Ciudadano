import "package:ciudadano/features/home/comunity/domain/entities/event.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_event.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class EventoCard extends StatelessWidget {
  final Evento evento;
  const EventoCard({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    final joined = evento.joined;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          evento.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${evento.fecha.day}/${evento.fecha.month}/${evento.fecha.year}",
        ),
        trailing:
            joined
                ? const Chip(
                  label: Text("Unido", style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                  shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
                )
                : TextButton(
                  onPressed:
                      () => context.read<EventoBloc>().add(
                        UnirseEvento(evento.id),
                      ),
                  child: const Text("Unirse"),
                ),
      ),
    );
  }
}
