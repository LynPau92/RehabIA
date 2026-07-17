import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/mascot_avatar.dart';
import '../../core/widgets/scroll_to_top_fab.dart';
import '../../core/widgets/skeleton_loader.dart';

/// Pantalla Home real (Módulo 1-2 de los requerimientos): saludo con la
/// mascota, resumen de progreso semanal, y acceso a la rutina del día
/// según la lesión y fase actual del paciente.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  bool _showScrollTopButton = false;

  @override
  void initState() {
    super.initState();
    // Escuchamos el scroll: si el usuario bajó más de 300px, mostramos
    // el botón; si vuelve a estar cerca del inicio, lo escondemos.
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 300;
      if (shouldShow != _showScrollTopButton) {
        setState(() => _showScrollTopButton = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: ScrollToTopFab(
        visible: _showScrollTopButton,
        onPressed: _scrollToTop,
      ),
      body: SafeArea(
        child: StreamBuilder<PatientProfile?>(
          // .watch() en vez de .get(): esto es un "flujo" que se
          // actualiza SOLO cada vez que la tabla cambia (por ejemplo,
          // al guardar una sesión nueva) — no hace falta salir y
          // volver a entrar a la pantalla para ver datos frescos.
          stream: (db.select(db.patientProfiles)
                ..orderBy([(t) => OrderingTerm.desc(t.id)])
                ..limit(1))
              .watchSingleOrNull(),
          builder: (context, profileSnapshot) {
            if (!profileSnapshot.hasData) {
              return const _HomeSkeleton();
            }
            final profile = profileSnapshot.data;
            if (profile == null) {
              return const Center(child: Text('Aún no hay un perfil guardado.'));
            }

            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                _GreetingHeader(profile: profile),
                const SizedBox(height: 20),
                _WeeklyProgressCard(profileId: profile.id),
                const SizedBox(height: 16),
                _TodayRoutineCard(profile: profile),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// --- Encabezado: mascota + saludo personalizado ---
class _GreetingHeader extends StatelessWidget {
  final PatientProfile profile;

  const _GreetingHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Esterilla simple detrás de la mascota (inspirado en cómo Luvu
        // ubica a su personaje "en una escena" en vez de flotando solo).
        // Es solo una elipse achatada en el color assistant bien suave.
        SizedBox(
          width: 88,
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 4,
                child: Container(
                  width: 76,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.assistant.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                child: MascotAvatar(size: 72, pose: MascotPose.saludando),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, ${profile.name}!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Sigamos avanzando en tu recuperación.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// --- Tarjeta de progreso semanal (Módulo 4) ---
/// Cuenta cuántas sesiones completó el usuario en los últimos 7 días.
class _WeeklyProgressCard extends ConsumerWidget {
  final int profileId;

  const _WeeklyProgressCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return StreamBuilder<List<Session>>(
      // Igual que arriba: .watch() se actualiza solo cuando se guarda
      // una sesión nueva, sin tener que salir y volver a esta pantalla.
      stream: (db.select(db.sessions)..where((s) => s.profileId.equals(profileId)))
          .watch(),
      builder: (context, snapshot) {
        final allSessions = snapshot.data ?? [];
        final sessionsThisWeek = allSessions
            .where((s) => s.date.isAfter(sevenDaysAgo))
            .length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department,
                      color: AppColors.success, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$sessionsThisWeek ${sessionsThisWeek == 1 ? "sesión" : "sesiones"} esta semana',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sessionsThisWeek == 0
                            ? '¡Hoy es un buen día para empezar!'
                            : '¡Vas muy bien, sigue así!',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// --- Tarjeta de la rutina del día + botón para comenzar ---
class _TodayRoutineCard extends ConsumerWidget {
  final PatientProfile profile;

  const _TodayRoutineCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    if (profile.injuryId == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No seleccionaste una lesión durante el registro.'),
        ),
      );
    }

    return FutureBuilder<Injury>(
      future: (db.select(db.injuries)..where((i) => i.id.equals(profile.injuryId!)))
          .getSingle(),
      builder: (context, injurySnapshot) {
        if (!injurySnapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: _RoutineCardSkeleton(),
            ),
          );
        }
        final injury = injurySnapshot.data!;

        return StreamBuilder<List<Exercise>>(
          stream: (db.select(db.exercises)
                ..where((e) => e.injuryId.equals(injury.id))
                ..where((e) => e.phase.equals(profile.currentPhase))
                ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
              .watch(),
          builder: (context, exSnapshot) {
            final exercises = exSnapshot.data ?? [];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rutina de hoy',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      injury.name,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fase ${profile.currentPhase} · ${exercises.length} ejercicios',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: exercises.isEmpty
                            ? null
                            // Mandamos TODA la lista de ejercicios de la
                            // fase actual — la pantalla de sesión arma
                            // el orden serie por serie automáticamente.
                            : () => context.push('/exercise-session', extra: exercises),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Comenzar sesión de hoy'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// --- Skeleton de toda la pantalla Home (mientras carga el perfil) ---
/// Imita la forma real: encabezado con mascota, tarjeta de progreso,
/// tarjeta de rutina — así el usuario "reconoce" la pantalla antes de
/// que termine de cargar, en vez de ver un spinner sin contexto.
class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 72, height: 72, borderRadius: BorderRadius.circular(36)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(height: 22),
                    const SizedBox(height: 8),
                    SkeletonBox(width: 180, height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SkeletonBox(height: 76, borderRadius: BorderRadius.all(Radius.circular(16))),
          const SizedBox(height: 16),
          const SkeletonBox(height: 160, borderRadius: BorderRadius.all(Radius.circular(16))),
        ],
      ),
    );
  }
}

/// --- Skeleton solo de la tarjeta de rutina (mientras carga la lesión) ---
class _RoutineCardSkeleton extends StatelessWidget {
  const _RoutineCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: 120, height: 18),
        const SizedBox(height: 10),
        SkeletonBox(width: 180, height: 14),
        const SizedBox(height: 16),
        const SkeletonBox(height: 44, borderRadius: BorderRadius.all(Radius.circular(14))),
      ],
    );
  }
}