import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_bottom_navigation_bar.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_header.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_sidebar.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class MainNavigation extends HookWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentNavigationBarIndex = useState(0);

    return Scaffold(
      appBar: const AppHeader(),
      drawer: const AppSidebar(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentNavigationBarIndex.value,
        onTap: (value) => currentNavigationBarIndex.value = value,
      ),
    );
  }
}
