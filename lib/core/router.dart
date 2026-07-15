import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/exercises/exercise_list_screen.dart';
import '../features/exercises/exercise_session_screen.dart';
import 'database/app_database.dart' show Exercise;
import '../features/progress/progress_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import 'widgets/main_scaffold.dart';

// Le da a go_router una identidad estable para el "Navigator" que vive
// dentro del shell (la barra inferior). No hace falta entender el
// detalle técnico todavía — es una pieza requerida por el patrón.
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Define las "rutas" (direcciones) de la app y qué pantalla corresponde
/// a cada una.
///
/// Aquí distinguimos dos tipos de rutas:
///   - Rutas "sueltas" (/onboarding, /exercises): pantallas de pantalla
///     completa, SIN la barra de navegación inferior.
///   - Rutas dentro del StatefulShellRoute (/home, /progress, /profile,
///     /settings): las 4 pestañas principales, CON la barra inferior,
///     envueltas por MainScaffold.
final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/exercises',
      builder: (context, state) => const ExerciseListScreen(),
    ),
    GoRoute(
      // Ahora recibe la LISTA completa de ejercicios de la sesión
      // (uno o varios) — la pantalla arma el orden serie por serie.
      path: '/exercise-session',
      builder: (context, state) =>
          ExerciseSessionScreen(exercises: state.extra as List<Exercise>),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/progress', builder: (context, state) => const ProgressScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
          ],
        ),
      ],
    ),
  ],
);