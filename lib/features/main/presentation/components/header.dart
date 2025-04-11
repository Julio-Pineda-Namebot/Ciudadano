import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Ciudadano", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
      centerTitle: true,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {
          // Drawer
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications), 
          color: Colors.white,
          onPressed: () {
            // Acción de notificaciones
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}