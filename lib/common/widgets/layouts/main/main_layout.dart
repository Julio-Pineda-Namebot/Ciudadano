import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/presentation/widgets/create_incident_form.dart";
import "package:ciudadano/common/widgets/header.dart";
import "package:ciudadano/common/widgets/navigations_bar.dart";
import "package:ciudadano/common/widgets/sidebar_menu.dart";
import "package:ciudadano/service_locator.dart";
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

  Widget _buildBody(bool isLoading, bool locationExists) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!locationExists) {
      return const Center(
        child: Text("No se pudo obtener la ubicación actual"),
      );
    }

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
      create: (context) => sl<LocationCubit>()..loadInitialLocation(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomHeader(scaffoldKey: _scaffoldKey),
        drawer: SidebarMenu(controller: _sidebarController),
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            return Center(
              child: _buildBody(state.isLoading, state.location != null),
            );
          },
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
