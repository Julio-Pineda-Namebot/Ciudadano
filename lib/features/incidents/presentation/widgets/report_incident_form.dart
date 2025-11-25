import "dart:io";

import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/get_location_cubit.dart";
import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/domain/params/report_incident_param.dart";
import "package:ciudadano/features/incidents/presentation/bloc/report_incident_cubit.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:image_picker/image_picker.dart";

class ReportIncidentForm extends HookWidget {
  final Function(Incident incident)? onReportIncident;

  const ReportIncidentForm({super.key, this.onReportIncident});

  @override
  Widget build(BuildContext context) {
    final reportIncidentCubit = useBlocProvider(
      () => sl<ReportIncidentCubit>(),
    );
    final reportIncidentCubitState = useBlocBuilder(reportIncidentCubit);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final image = useState<File?>(null);
    final incidentType = useState<IncidentType?>(null);
    final description = useState<String?>(null);

    Future<void> pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      }
    }

    Widget buildImageInput() {
      return Column(
        children: [
          Row(
            spacing: 6,
            children: [
              IconButton(
                onPressed: () => pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => pickImage(ImageSource.gallery),
                  child: const Text("Abrir galería"),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          image.value != null
              ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.file(image.value!, fit: BoxFit.contain),
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

    void resetForm() {
      formKey.currentState?.reset();
      image.value = null;
      incidentType.value = null;
      description.value = null;
    }

    useBlocListener(reportIncidentCubit, (_, state, __) {
      if (state is ReportIncidentSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incidencia enviada exitosamente")),
        );
        resetForm();
        if (onReportIncident != null) {
          onReportIncident!(state.incidentCreated);
        }
        return;
      }

      if (state is ReportIncidentErrorState) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.message)));
      }
    });

    return Form(
      key: formKey,
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
                  buildImageInput(),
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
                    initialValue: incidentType.value?.value,
                    items:
                        IncidentType.values
                            .map(
                              (type) => DropdownMenuItem(
                                value: type.value,
                                child: Text(type.value),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      incidentType.value = IncidentType.values.firstWhere(
                        (type) => type.value == value,
                      );
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
                    onSaved: (value) => description.value = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese una descripción";
                      }

                      if (value.trim().length < 3) {
                        return "Debe tener al menos 10 caracteres";
                      }

                      if (value.trim().length > 500) {
                        return "No puede tener más de 500 caracteres";
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  reportIncidentCubitState is ReportIncidentLoadingState
                      ? null
                      : () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          if (image.value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Debe seleccionar una imagen. 📸",
                                ),
                              ),
                            );
                            return;
                          }

                          reportIncidentCubit.reportIncident(
                            ReportIncidentParam(
                              incidentType: incidentType.value!,
                              description: description.value!,
                              image: image.value!,
                              location:
                                  BlocProvider.of<GetLocationCubit>(
                                    context,
                                  ).state.location!,
                            ),
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (reportIncidentCubitState
                      is ReportIncidentLoadingState) ...[
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(0, 0, 0, .5),
                      ),
                    ),
                  ],
                  const Text("Enviar Incidencia"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
