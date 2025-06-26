import "package:ciudadano/features/incidents/presentation/widgets/create_incident_form.dart";
import "package:flutter/widgets.dart";

class CreateIncidentPage extends StatelessWidget {
  const CreateIncidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: CreateIncidentForm(),
    );
  }
}
