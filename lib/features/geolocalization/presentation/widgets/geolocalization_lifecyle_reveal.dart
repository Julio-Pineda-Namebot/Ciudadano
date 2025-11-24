import "package:ciudadano/features/geolocalization/presentation/bloc/geolocalization_permission_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class GeolocalizationLifecyleReveal extends StatefulWidget {
  final Widget child;

  const GeolocalizationLifecyleReveal({super.key, required this.child});

  @override
  State<GeolocalizationLifecyleReveal> createState() =>
      _GeolocalizationLifecyleRevealState();
}

class _GeolocalizationLifecyleRevealState
    extends State<GeolocalizationLifecyleReveal>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<GeolocalizationPermissionCubit>().evaluate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
