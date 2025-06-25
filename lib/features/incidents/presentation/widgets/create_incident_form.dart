import "package:flutter/material.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";

class CreateIncidentForm extends StatefulWidget {
  const CreateIncidentForm({super.key});

  @override
  State<CreateIncidentForm> createState() => _CreateIncidentFormState();
}

class _CreateIncidentFormState extends State<CreateIncidentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _incidentType;
  String? _description;
  File? _image;

  final List<String> _incidentTypes = ["Robo", "Accidente", "Vandalismo"];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Tipo de incidencia",
              border: OutlineInputBorder(),
            ),
            value: _incidentType,
            items:
                _incidentTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _incidentType = value;
              });
            },
            validator: (value) => value == null ? "Seleccione un tipo" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Descripción",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onSaved: (value) => _description = value,
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? "Ingrese una descripción"
                        : null,
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Subir imagen"),
              ),
              const SizedBox(width: 12),
              _image != null
                  ? Image.file(
                    _image!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                  : const Text("Ninguna imagen seleccionada"),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Aquí puedes manejar el envío del formulario
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Incidencia enviada")),
                  );
                }
              },
              child: const Text("Enviar"),
            ),
          ),
        ],
      ),
    );
  }
}
