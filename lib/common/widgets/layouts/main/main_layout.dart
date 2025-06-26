import "package:ciudadano/common/widgets/header.dart";
import "package:ciudadano/common/widgets/navigations_bar.dart";
import "package:ciudadano/common/widgets/pages/home/home_page.dart";
import "package:ciudadano/common/widgets/sidebar_menu.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/presentation/page/create_incident_page.dart";
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

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().loadInitialLocation();
  }

  bool _isLocationLoading = true;
  bool _isLocationAvailable = false;

  Widget _buildBody() {
    if (_isLocationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isLocationAvailable) {
      return IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          CreateIncidentPage(),
          // ProfilePage(), // Uncomment when ProfilePage is implemented
        ],
      );
    }

    return const Center(child: Text("No se pudo obtener la ubicación actual."));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state.location != null) {
          setState(() {
            _isLocationAvailable = true;
            _isLocationLoading = state.isLoading;
          });
        } else if (state.isLoading) {
          setState(() {
            _isLocationAvailable = false;
            _isLocationLoading = true;
          });
        } else {
          setState(() {
            _isLocationAvailable = false;
            _isLocationLoading = false;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomHeader(scaffoldKey: _scaffoldKey),
        drawer:
            _isLocationAvailable
                ? SidebarMenu(controller: _sidebarController)
                : null,
        body: _buildBody(),
        bottomNavigationBar:
            _isLocationAvailable
                ? CustomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                )
                : null,
      ),
    );
  }
}
