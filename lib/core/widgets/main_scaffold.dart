import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';

/// Envuelve las 4 pestañas principales (Inicio, Progreso, Perfil,
/// Configuración) con una única barra de navegación inferior.
///
/// `navigationShell` lo provee go_router: sabe en qué pestaña estás
/// (`currentIndex`) y cómo cambiar a otra (`goBranch`), mientras
/// mantiene el estado de cada pestaña por separado (por ejemplo, si
/// haces scroll en Progreso y cambias a Perfil, al volver seguirás en
/// el mismo punto del scroll — no se reinicia la pestaña).
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  void _onTap(int index) {
    // initialLocation: true hace que, si tocas la pestaña en la que ya
    // estás, regrese a su pantalla inicial (por si navegaste más adentro
    // dentro de esa misma pestaña).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El body es el contenido de la pestaña activa.
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        backgroundColor: AppColors.cardBackground,
        indicatorColor: AppColors.primary.withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.show_chart, color: AppColors.primary),
            label: 'Progreso',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            selectedIcon: Icon(Icons.settings, color: AppColors.primary),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}