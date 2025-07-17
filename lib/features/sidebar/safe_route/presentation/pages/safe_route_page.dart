import "dart:async";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_bloc.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/bloc/route_event.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/widgets/animated_menu.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/widgets/safe_map.dart";
// import "package:ciudadano/features/sidebar/safe_route/presentation/widgets/route_instruction_card.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class SafeRoutePage extends StatefulWidget {
  const SafeRoutePage({super.key});

  @override
  State<SafeRoutePage> createState() => _SafeRoutePageState();
}

class _SafeRoutePageState extends State<SafeRoutePage>
    with SingleTickerProviderStateMixin {
  LatLng? currentLocation;
  LatLng? destination;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  bool _menuVisible = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _getCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

  void _onTapMap(LatLng latlng) {
    setState(() {
      destination = latlng;
    });

    if (currentLocation != null && destination != null) {
      context.read<RouteBloc>().add(
            LoadRouteEvent(
              currentLocation!.latitude,
              currentLocation!.longitude,
              destination!.latitude,
              destination!.longitude,
            ),
          );
    }
  }

  void _startRoute() {
    if (currentLocation == null || destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes seleccionar un punto de destino en el mapa."),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    _elapsedTime = Duration.zero;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void _cancelRoute() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Cancelar ruta?"),
        content:
            const Text("¿Estás seguro de que deseas cancelar el recorrido actual?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _timer?.cancel();
              setState(() {
                _elapsedTime = Duration.zero;
                destination = null;
              });
              Navigator.pop(context);
            },
            child: const Text("Sí, cancelar"),
          ),
        ],
      ),
    );
  }

  void _toggleMenu() {
    setState(() {
      _menuVisible = !_menuVisible;
    });

    if (_menuVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recorrido Seguro"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_menuVisible ? Icons.close : Icons.menu),
            onPressed: _toggleMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedMenu(
            animation: _slideAnimation,
            visible: _menuVisible,
            elapsedTime: _elapsedTime,
            onStart: _startRoute,
            onCancel: _cancelRoute,
          ),
          Expanded(
            child: currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : SafeMap(
                    currentLocation: currentLocation!,
                    destination: destination,
                    onTapMap: _onTapMap,
                  ),
          ),
        ],
      ),
    );
  }
}
