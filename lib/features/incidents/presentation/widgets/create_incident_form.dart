import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/data/models/create_incident_model.dart";
import "package:ciudadano/features/incidents/presentation/bloc/create_incident/create_incident_bloc.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "dart:io";
import "package:image_picker/image_picker.dart";

class CreateIncidentForm extends StatefulWidget {
  final VoidCallback? onCreateIncident;

  const CreateIncidentForm({super.key, this.onCreateIncident});

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

  _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _incidentType = null;
      _description = null;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateIncidentBloc>(),
      child: BlocListener<CreateIncidentBloc, CreateIncidentState>(
        listener: (context, state) {
          if (state is CreateIncidentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Incidencia enviada exitosamente")),
            );
            _resetForm();
            widget.onCreateIncident?.call();
          } else if (state is CreateIncidentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Form(
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                            (value) =>
                                value == null ? "Seleccione un tipo" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Descripción",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onSaved: (value) => _description = value,
                        validator: ( value) {
                          if(value == null || value.isEmpty){
                            return "Ingrese una descripción";
                          }

                          if(value.trim().length < 3){
                            return "Debe tener al menos 10 caracteres";
                          }

                          if(value.trim().length > 500){
                            return "No puede tener más de 500 caracteres";
                          }
                          
                          return null;
                        }
                            
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              BlocBuilder<CreateIncidentBloc, CreateIncidentState>(
                builder: (context, state) {
                  return Opacity(
                    opacity: state is CreateIncidentLoading ? 0.5 : 1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if(_image == null){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Debe seleccionar una imagen. 📸"))
                            );
                            return;
                          }

                          _formKey.currentState!.save();

                          context.read<CreateIncidentBloc>().add(
                            CreateIncidentSubmit(
                              CreateIncidentModel(
                                description: _description!,
                                incidentType: _incidentType!,
                                image: _image!,
                                location: sl<LocationCubit>().state.location!,
                              ),
                            ),
                          );

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text("Incidencia enviada")),
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child:
                          state is CreateIncidentLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text("Enviar incidencia"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
