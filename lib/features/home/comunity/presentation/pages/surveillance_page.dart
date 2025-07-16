import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_bloc.dart";
import "package:ciudadano/features/home/comunity/presentation/bloc/surveillance/cam_event.dart";
import "package:ciudadano/features/home/comunity/presentation/widgets/surveillance/cam_list_widget.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class VigilanciaSection extends StatelessWidget {
  const VigilanciaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CamBloc>()..add(CargarCamaras()),
      child: const CamListWidget(),
    );
  }
}