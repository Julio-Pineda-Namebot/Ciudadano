import "package:ciudadano/features/home/incidents/data/incident_remote_datasource.dart";
import "package:ciudadano/features/home/incidents/presentation/bloc/map_bloc.dart";
import "package:ciudadano/features/home/incidents/presentation/bloc/map_event.dart";
import "package:ciudadano/features/home/incidents/presentation/widgets/create_incident_form.dart";
import "package:ciudadano/features/home/incidents/repository/incident_repository_impl.dart";
import "package:ciudadano/features/home/incidents/usercases/get_current_location.dart";
import "package:ciudadano/features/home/incidents/usercases/get_incidents.dart";
import "package:ciudadano/common/widgets/header.dart";
import "package:ciudadano/common/widgets/navigations_bar.dart";
import "package:ciudadano/common/widgets/sidebar_menu.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sidebarx/sidebarx.dart";

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sidebarController = SidebarXController(
    selectedIndex: -1,
    extended: true,
  );

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const MainLayout();
      case 1:
        return Container(
          padding: const EdgeInsets.all(16),
          child: const CreateIncidentForm(),
        );
      case 2:
      // return const ProfilePage();
      default:
        return const Center(child: Text("Página no encontrada"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => MapBloc(
            getCurrentLocation: GetCurrentLocation(),
            getNearbyIncidents: GetNearbyIncidents(
              IncidentRepositoryImpl(
                remoteDatasource: IncidentRemoteDatasource(),
              ),
            ),
          )..add(LoadCurrentLocation()),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomHeader(scaffoldKey: _scaffoldKey),
        drawer: SidebarMenu(controller: _sidebarController),
        body: Center(child: _buildBody()),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
