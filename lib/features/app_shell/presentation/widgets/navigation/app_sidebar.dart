import "package:ciudadano/features/app_shell/presentation/hooks/use_sidebar_controller.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:sidebarx/sidebarx.dart";

class AppSidebar extends HookWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = useSidebarController(
      selectedIndex: -1,
      extended: true,
    );
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return SidebarX(
      controller: sidebarController,
      theme: SidebarXTheme(
        itemTextPadding: const EdgeInsets.only(left: 30),
        decoration: const BoxDecoration(color: Colors.black),
        textStyle: const TextStyle(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        selectedTextStyle: const TextStyle(color: Colors.white),
        selectedItemDecoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
        ),
        itemMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        selectedIconTheme: const IconThemeData(color: Colors.white),
        selectedItemTextPadding: const EdgeInsets.only(left: 20),
      ),
      extendedTheme: const SidebarXTheme(width: 250),
      headerBuilder: (context, extended) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 90, bottom: 10),
          color: Colors.black,
          child:
              extended
                  ? const Text(
                    "Menú",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : const Text(
                    "M",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
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
      items: [
        SidebarXItem(
          icon: Icons.person,
          label: "Perfil",
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const UserProfilePage()),
            // ).then((_) => sidebarController.selectIndex(-1));
          },
        ),
        SidebarXItem(
          icon: Icons.newspaper,
          label: "Noticias",
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const NewsPage()),
            // ).then((_) => sidebarController.selectIndex(-1));
          },
        ),
        SidebarXItem(
          icon: Icons.alt_route,
          label: "Recorrido Seguro",
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder:
            //         (context) => BlocProvider(
            //           create: (context) => sl<NearbyIncidentsBloc>(),
            //           child: const SafeRoutePage(),
            //         ),
            //   ),
            // ).then((_) => sidebarController.selectIndex(-1));
          },
        ),
        SidebarXItem(
          icon: Icons.info,
          label: "Acerca de Ciudadano",
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const AboutPage()),
            // ).then((_) => sidebarController.selectIndex(-1));
          },
        ),
      ],
      footerItems: [
        SidebarXItem(
          icon: Icons.logout,
          label: "Cerrar Sesión",
          onTap: () async {
            Scaffold.of(context).closeDrawer();
            await Future.delayed(const Duration(milliseconds: 300));
            authCubit.logout();
            // BlocProvider.of<AuthCubit>(context).logout();
          },
        ),
      ],
    );
  }
}
