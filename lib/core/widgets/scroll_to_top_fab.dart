import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Botón flotante "volver arriba", pensado para pantallas largas con
/// scroll (Progreso, catálogo de ejercicios, etc.).
///
/// Es un widget "tonto" (no sabe nada de scroll por sí mismo) — solo
/// recibe si debe mostrarse (`visible`) y qué hacer al tocarlo
/// (`onPressed`). La pantalla que lo usa es la que decide cuándo
/// mostrarlo, según la posición del scroll.
class ScrollToTopFab extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const ScrollToTopFab({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // AnimatedScale + AnimatedOpacity le dan una aparición/desaparición
    // suave en vez de que el botón aparezca de golpe.
    return AnimatedScale(
      scale: visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          heroTag: 'scrollToTop', // evita conflicto si hay otro FAB en la app
          backgroundColor: AppColors.success,
          onPressed: onPressed,
          child: const Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),
    );
  }
}