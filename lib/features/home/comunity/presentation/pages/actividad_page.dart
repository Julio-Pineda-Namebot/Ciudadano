import "package:ciudadano/features/home/comunity/presentation/widgets/actividad_list_widget.dart";
import "package:ciudadano/features/home/comunity/presentation/widgets/activity_input_widget.dart";
import "package:flutter/material.dart";

class ActividadPage extends StatelessWidget {
  const ActividadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActividadInputWidget(),
                SizedBox(height: 24),
                Text(
                  "Actividad Reciente",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                ActividadListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
