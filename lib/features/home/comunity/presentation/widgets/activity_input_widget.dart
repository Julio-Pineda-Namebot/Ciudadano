import "package:ciudadano/features/home/comunity/presentation/bloc/activity_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/activity_event.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ActividadInputWidget extends StatefulWidget {
  const ActividadInputWidget({super.key});

  @override
  State<ActividadInputWidget> createState() => _ActividadInputWidgetState();
}

class _ActividadInputWidgetState extends State<ActividadInputWidget> {
  final _controller = TextEditingController();

  void _publicar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) {
      return;
    }
    context.read<ActividadBloc>().add(
      PublicarActividad(autor: "Tú", mensaje: texto),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Publicar Actualización",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Comparte noticias o preocupaciones con vecinos…",
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: _publicar,
            child: const Text("Publicar"),
          ),
        ),
      ],
    );
  }
}
