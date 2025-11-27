import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class ObtainingLocationPage extends HookWidget {
  const ObtainingLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    final pulseAnimation = useAnimation(
      Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
    );

    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
    );

    final rotateAnimation = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear),
      ),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildPulsingCircle(
                    scale: pulseAnimation * 2.5,
                    opacity: fadeAnimation * 0.15,
                    color: Colors.black,
                  ),
                  _buildPulsingCircle(
                    scale: pulseAnimation * 2.0,
                    opacity: fadeAnimation * 0.2,
                    color: Colors.black,
                  ),
                  _buildPulsingCircle(
                    scale: pulseAnimation * 1.5,
                    opacity: fadeAnimation * 0.25,
                    color: Colors.black,
                  ),

                  Transform.scale(
                    scale: pulseAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Transform.rotate(
                        angle: rotateAnimation * 0.2,
                        child: const Icon(
                          Icons.my_location_rounded,
                          size: 80,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  Transform.scale(
                    scale: pulseAnimation * 0.3,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(fadeAnimation),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20 * fadeAnimation,
                            spreadRadius: 5 * fadeAnimation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              const Text(
                "Obteniendo ubicación",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                "Estamos localizando tu posición actual...\nEsto puede tomar unos segundos.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPulsingCircle({
    required double scale,
    required double opacity,
    required Color color,
  }) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
          border: Border.all(color: color.withOpacity(opacity * 2), width: 2),
        ),
      ),
    );
  }
}
