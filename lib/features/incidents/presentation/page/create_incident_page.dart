import "package:ciudadano/features/incidents/presentation/widgets/create_incident_form.dart";
import "package:flutter/widgets.dart";

class CreateIncidentPage extends StatelessWidget {
  final VoidCallback? onCreateIncident;
  const CreateIncidentPage({super.key, this.onCreateIncident});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: CreateIncidentForm(
        onCreateIncident: () => onCreateIncident?.call(),
      ),
    );
  }
}
