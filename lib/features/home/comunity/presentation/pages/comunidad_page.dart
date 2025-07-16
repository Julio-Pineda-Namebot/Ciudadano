import "package:ciudadano/features/home/comunity/presentation/pages/actividad_page.dart";
import "package:flutter/material.dart";

class ComunidadPage extends StatefulWidget {
  const ComunidadPage({super.key});

  @override
  State<ComunidadPage> createState() => _ComunidadPageState();
}

class _ComunidadPageState extends State<ComunidadPage> {
  int _current = 0; // 0 = Actividad, 1 = Eventos, 2 = Vigilancia

  void _select(int index) => setState(() => _current = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidad"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // --- Botones ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                _TabButton(
                  selected: _current == 0,
                  icon: Icons.chat_rounded,
                  label: "Actividad",
                  onTap: () => _select(0),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  selected: _current == 1,
                  icon: Icons.event,
                  label: "Eventos",
                  onTap: () => _select(1),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  selected: _current == 2,
                  icon: Icons.videocam,
                  label: "Vigilancia",
                  onTap: () => _select(2),
                ),
              ],
            ),
          ),

          // --- Contenido dinámico ---
          Expanded(
            child: IndexedStack(
              index: _current,
              children: const [
                // Si tu ActividadPage lleva Scaffold, crea una versión sin él.
                ActividadPage(),

                // Placeholder de Eventos (drawer/formulario se hará luego)
                Center(child: Text("Eventos (próximamente)…")),

                // Placeholder de Vigilancia (cards con GIFs se hará luego)
                Center(child: Text("Vigilancia (próximamente)…")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón “tarjeta” con icono + label, similar al de la maqueta.
class _TabButton extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TabButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
                color: selected ? Colors.white : Colors.black87,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
