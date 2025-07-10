import "package:ciudadano/common/widgets/header.dart";
import "package:ciudadano/common/widgets/navigations_bar.dart";
import "package:ciudadano/common/widgets/pages/home/home_page.dart";
import "package:ciudadano/common/widgets/sidebar_menu.dart";
import "package:ciudadano/features/chats/presentation/pages/chats_page.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc_listeners.dart";
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

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody(bool isLocationLoading, bool isLocationAvailable) {
    if (isLocationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isLocationAvailable) {
      return BlocListener<SocketBloc, SocketState>(
        listener: (context, state) {
          if (state is SocketConnectedState) {
            incidentsCreated(context);
            chatGroupCreated(context);
            chatGroupMessageSent(context);
          }
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            const HomePage(),
            CreateIncidentPage(onCreateIncident: () => _onItemTapped(0)),
            const ChatsPage(),
          ],
        ),
      );
    }

    return const Center(child: Text("No se pudo obtener la ubicación actual."));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final isLocationLoading = state.isLoading;
        final isLocationAvailable = state.location != null;

        return Scaffold(
          key: _scaffoldKey,
          appBar: CustomHeader(scaffoldKey: _scaffoldKey),
          drawer:
              isLocationAvailable
                  ? SidebarMenu(controller: _sidebarController)
                  : null,
          body: _buildBody(isLocationLoading, isLocationAvailable),
          bottomNavigationBar:
              isLocationAvailable
                  ? CustomNavigationBar(
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  )
                  : null,
        );
      },
    );
  }
}
