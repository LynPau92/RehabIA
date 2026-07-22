import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Botón flotante "volver arriba", reutilizable en cualquier pantalla
/// larga con scroll (Home, Progreso, catálogo de ejercicios, etc.).
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
    return AnimatedScale(
      scale: visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          // heroTag: null desactiva la animación "Hero" para este
          // botón por completo. Como varias pantallas usan este mismo
          // widget, y con el patrón de pestañas pueden convivir
          // montadas al mismo tiempo, usar un tag fijo (aunque fuera
          // único por nombre) igual puede chocar si el mismo texto se
          // reutiliza sin querer. null es la forma más simple y segura
          // de decir "este FAB no necesita esa animación".
          heroTag: null,
          backgroundColor: AppColors.success,
          onPressed: onPressed,
          child: const Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),
    );
  }
}