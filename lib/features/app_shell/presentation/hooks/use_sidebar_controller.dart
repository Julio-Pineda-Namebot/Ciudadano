import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:sidebarx/sidebarx.dart";

class _SidebarController extends Hook<SidebarXController> {
  final int selectedIndex;
  final bool extended;

  const _SidebarController({
    required this.selectedIndex,
    required this.extended,
  });

  @override
  _SidebarControllerState createState() => _SidebarControllerState();
}

class _SidebarControllerState
    extends HookState<SidebarXController, _SidebarController> {
  late final SidebarXController controller;

  @override
  void initHook() {
    controller = SidebarXController(
      selectedIndex: hook.selectedIndex,
      extended: hook.extended,
    );
    super.initHook();
  }

  @override
  SidebarXController build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

SidebarXController useSidebarController({
  int selectedIndex = 0,
  bool extended = true,
}) {
  return use(
    _SidebarController(selectedIndex: selectedIndex, extended: extended),
  );
}
