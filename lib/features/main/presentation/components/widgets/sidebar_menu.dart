import 'package:ciudadano/features/sidebar/about/about_page.dart';
import 'package:ciudadano/features/sidebar/profile/presentation/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarMenu extends StatelessWidget {
  final SidebarXController controller;

  const SidebarMenu({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      items: [
        SidebarXItem(icon: Icons.person, label: 'Perfil',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            ).then((_) => controller.selectIndex(-1));
          }
        ),
        SidebarXItem(icon: Icons.newspaper, label: 'Noticias',
          onTap: () {}
        ),
        SidebarXItem(icon: Icons.alt_route, label: 'Recorrido Seguro',
          onTap: () {}
        ),
        SidebarXItem(icon: Icons.info, label: 'Acerca de Ciudadano', 
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ).then((_) => controller.selectIndex(-1));
          }
        ),
      ],
      headerBuilder: (context, extended) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 90, bottom: 10),
          color: Colors.black,
          child: extended
           ? const Text(
            'Menú',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 28,
              fontWeight: FontWeight.bold
            ),
          )
          : const Text(
            'M',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
        );
      },
      headerDivider: const Divider(
        color: Colors.white,
        height: 0.5,
        thickness: 0.4,
        indent: 16,
        endIndent: 16,
      ),
      theme: SidebarXTheme(
        itemTextPadding: const EdgeInsets.only(left: 30),
        decoration: BoxDecoration(color: Colors.black),
        textStyle: const TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        selectedTextStyle: const TextStyle(color: Colors.white),
        selectedItemDecoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
        ),
        itemMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0,),
        selectedIconTheme: const IconThemeData(color: Colors.white),
        selectedItemTextPadding: const EdgeInsets.only(left: 20),
      ),
      footerItems: [
        SidebarXItem(icon: Icons.logout, label: 'Cerrar Sesión',
          onTap: () {}
        ),
      ],
      extendedTheme: const SidebarXTheme(width: 250),
    );
  }
}
