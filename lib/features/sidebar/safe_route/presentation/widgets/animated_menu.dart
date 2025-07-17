import "package:ciudadano/features/sidebar/safe_route/presentation/widgets/elapsed_time_display.dart";
import "package:ciudadano/features/sidebar/safe_route/presentation/widgets/route_action_button.dart";
import "package:flutter/material.dart";

class AnimatedMenu extends StatelessWidget {
  final Animation<double> animation;
  final bool visible;
  final Duration elapsedTime;
  final VoidCallback onStart;
  final VoidCallback onCancel;

  const AnimatedMenu({
    super.key,
    required this.animation,
    required this.visible,
    required this.elapsedTime,
    required this.onStart,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value * 100),
          child: Container(
            height: visible ? 100 : 0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: visible
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        RouteActionButton(
                          onPressed: onStart,
                          startColor: const Color(0xFF4CAF50),
                          endColor: const Color(0xFF45A049),
                          icon: Icons.play_arrow,
                          label: "Iniciar",
                        ),
                        const SizedBox(width: 12),
                        RouteActionButton(
                          onPressed: onCancel,
                          startColor: const Color(0xFFE53935),
                          endColor: const Color(0xFFD32F2F),
                          icon: Icons.close,
                          label: "Cancelar",
                        ),
                        const SizedBox(width: 12),
                        ElapsedTimeDisplay(elapsed: elapsedTime),
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}