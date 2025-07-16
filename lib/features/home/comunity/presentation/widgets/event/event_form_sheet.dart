import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/event/event_event.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class EventoFormSheet extends StatefulWidget {
  const EventoFormSheet({super.key});

  @override
  State<EventoFormSheet> createState() => _EventoFormSheetState();
}

class _EventoFormSheetState extends State<EventoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  DateTime? _fecha;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: now,
      lastDate: DateTime(now.year + 5),
      locale: const Locale("es"),
    );
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  void _guardar() {
    if (!_formKey.currentState!.validate() || _fecha == null) {
      return;
    }

    context.read<EventoBloc>().add(
      CrearEvento(nombre: _nameCtrl.text.trim(), fecha: _fecha!),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: kElevationToShadow[8],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Nuevo evento",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              /// Nombre
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre del evento",
                  prefixIcon: Icon(Icons.event_note_outlined),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? "Ingresa un nombre"
                            : null,
              ),
              const SizedBox(height: 16),

              /// Fecha
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Fecha",
                      hintText: "Selecciona una fecha",
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.edit_calendar_outlined),
                      ),
                    ),
                    controller: TextEditingController(
                      text:
                          _fecha != null
                              ? DateFormat("dd/MM/yyyy").format(_fecha!)
                              : "",
                    ),
                    validator: (_) => _fecha == null ? "Elige la fecha" : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _guardar,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text("Guardar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
