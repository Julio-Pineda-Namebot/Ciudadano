import "package:ciudadano/common/widgets/header.dart";
import "package:ciudadano/common/widgets/navigations_bar.dart";
import "package:ciudadano/common/widgets/pages/home/home_page.dart";
import "package:ciudadano/common/widgets/sidebar_menu.dart";
import "package:ciudadano/features/auth/presentation/pages/login_page.dart";
import "package:ciudadano/features/chats/data/source/chat_ws_source.dart";
import "package:ciudadano/features/chats/presentation/pages/chats_page.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/presentation/page/report_incident_page.dart";
import "package:ciudadano/features/sidebar/logout/bloc/logout_bloc.dart";
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

  @override
  void initState() {
    sl<ChatWsSource>().connect();
    super.initState();
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    sl<ChatWsSource>().disconnect();
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
      return IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePage(),
          ReportIncidentPage(onReportIncident: () => _onItemTapped(0)),
          const ChatsPage(),
        ],
      );
    }

    return const Center(child: Text("No se pudo obtener la ubicación actual."));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return MultiBlocListener(
          listeners: [
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  temporalClearMemoryDataSources();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomHeader(scaffoldKey: _scaffoldKey),
            drawer:
                state is LocationLoadedState
                    ? SidebarMenu(controller: _sidebarController)
                    : null,
            body: _buildBody(
              state is LocationLoadingState,
              state is LocationLoadedState,
            ),
            bottomNavigationBar:
                state is LocationLoadedState
                    ? CustomNavigationBar(
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                    )
                    : null,
          ),
        );
      },
    );
  }
}
