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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildImageInput() {
    return Column(
      children: [
        Row(
          spacing: 6,
          children: [
            IconButton(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text("Abrir galería"),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        _image != null
            ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.file(_image!, fit: BoxFit.contain),
            )
            : Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 40),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Capturar imagen",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildImageInput(),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _incidentType = value;
                      });
                    },
                    validator:
                        (value) => value == null ? "Seleccione un tipo" : null,
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Aquí puedes manejar el envío del formulario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Incidencia enviada")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Enviar"),
          ),
        ],
      ),
    );
  }
}
