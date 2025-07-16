import "package:ciudadano/features/home/comunity/presentation/bloc/activity_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/activity_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ActividadListWidget extends StatelessWidget {
  const ActividadListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActividadBloc, ActividadState>(
      builder: (context, state) {
        if (state is ActividadLoading || state is ActividadInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ActividadError) {
          return Center(child: Text(state.mensaje));
        }
        final actividades = (state as ActividadLoaded).actividades;
        return ListView.separated(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: actividades.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final act = actividades[index];
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${act.autor}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: act.mensaje),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
