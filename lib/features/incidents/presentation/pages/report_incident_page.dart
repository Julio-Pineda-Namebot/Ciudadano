import "package:ciudadano/features/incidents/domain/entity/incident.dart";
import "package:ciudadano/features/incidents/presentation/widgets/report_incident_form.dart";
import "package:flutter/material.dart";

class ReportIncidentPage extends StatelessWidget {
  final Function(Incident incident)? onReportIncident;

  const ReportIncidentPage({super.key, this.onReportIncident});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ReportIncidentForm(onReportIncident: onReportIncident),
    );
  }
}
