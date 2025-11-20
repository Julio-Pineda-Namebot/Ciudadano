import "package:ciudadano/features/incidents/presentation/widgets/report_incident_form.dart";
import "package:flutter/widgets.dart";

class ReportIncidentPage extends StatelessWidget {
  final VoidCallback? onReportIncident;
  const ReportIncidentPage({super.key, this.onReportIncident});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ReportIncidentForm(
        onReportIncident: () => onReportIncident?.call(),
      ),
    );
  }
}
