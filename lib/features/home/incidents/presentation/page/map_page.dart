import 'package:ciudadano/features/home/incidents/data/incident_remote_datasource.dart';
import 'package:ciudadano/features/home/incidents/presentation/bloc/map_bloc.dart';
import 'package:ciudadano/features/home/incidents/presentation/bloc/map_event.dart';
import 'package:ciudadano/features/home/incidents/presentation/bloc/map_state.dart';
import 'package:ciudadano/features/home/incidents/presentation/widgets/incident_marker.dart';
import 'package:ciudadano/features/home/incidents/presentation/widgets/your_location_marker.dart';
import 'package:ciudadano/features/home/incidents/repository/incident_repository_impl.dart';
import 'package:ciudadano/features/home/incidents/usercases/get_current_location.dart';
import 'package:ciudadano/features/home/incidents/usercases/get_incidents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  
  Color getIncidentColor(String type) {
    switch (type.toLowerCase()) {
      case 'robo':
        return Colors.black;
      case 'accidente':
        return Colors.red;
      case 'vandalismo':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapBloc(
          getCurrentLocation: GetCurrentLocation(),
          getIncidents: GetIncidents(IncidentRepositoryImpl(
            remoteDatasource: IncidentRemoteDatasource(),
          )),
        )..add(LoadCurrentLocation()),
      child: Scaffold(
        body: BlocListener<MapBloc, MapState>(
          listener: (context, state) {
            if (state is MapLoaded) {
              _currentLocation = state.location;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mapController.move(state.location, _mapController.camera.zoom);
              });
            }
          },
          child: BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              final isLoading = state is MapLoading;

              return Skeletonizer(
                enabled: isLoading,
                child: Stack(
                  children: [
                    if (state is MapLoaded)
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: state.location,
                          initialZoom: 17.0,
                          minZoom: 16.5,
                          maxZoom: 17.5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: state.location,
                                width: 80,
                                height: 80,
                                child: const YourLocationMarker(),
                              ),
                              // marcadores de incidentes
                              ...state.incidents.map(
                                (incident) => Marker(
                                  point: LatLng(incident.latitude, incident.longitude),
                                  width: 80,
                                  height: 80,
                                  child: IncidentMarker(
                                    description: incident.description,
                                    type: incident.incidentType,
                                    imageUrl: incident.imageUrl ?? '',
                                    color: getIncidentColor(incident.incidentType),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    else
                      Container(
                        color: Colors.grey[300],
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    if (state is MapLoaded)
                      Positioned(
                        bottom: 20,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () {
                            if (_currentLocation != null) {
                              _mapController.move(
                                _currentLocation!, 
                                17.0,
                              );
                            }
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.my_location),
                        ),
                      ),
                    if (state is MapError && !isLoading)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              "No pudimos acceder a tu ubicación.",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<MapBloc>().add(LoadCurrentLocation());
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Reintentar"),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
