import 'package:ciudadano/features/main/presentation/components/header.dart';
import 'package:ciudadano/features/main/presentation/components/navigations_bar.dart';
import 'package:ciudadano/features/main/presentation/components/widgets/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sidebarController = SidebarXController(selectedIndex: -1, extended: true);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomHeader(scaffoldKey: _scaffoldKey),
      drawer: SidebarMenu(controller: _sidebarController),
      body: Center(
        child: Text("Página $_selectedIndex"),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

