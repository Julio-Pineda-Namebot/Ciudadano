import "package:ciudadano/features/app_shell/presentation/pages/home/home_page.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/events/listen_events.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_bottom_navigation_bar.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_header.dart";
import "package:ciudadano/features/app_shell/presentation/widgets/navigation/app_sidebar.dart";
import "package:ciudadano/features/chats/presentation/pages/chats_page.dart";
import "package:ciudadano/features/incidents/presentation/pages/report_incident_page.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class MainNavigation extends HookWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentNavigationBarIndex = useState(0);

    return ListenEvents(
      child: Scaffold(
        appBar: const AppHeader(),
        drawer: const AppSidebar(),
        body: IndexedStack(
          index: currentNavigationBarIndex.value,
          children: [
            const HomePage(),
            ReportIncidentPage(
              onReportIncident:
                  (incident) => currentNavigationBarIndex.value = 0,
            ),
            const ChatsPage(),
          ],
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: currentNavigationBarIndex.value,
          onTap: (value) => currentNavigationBarIndex.value = value,
        ),
      ),
    );
  }
}
