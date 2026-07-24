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

class _GreetingHeader extends StatelessWidget {
  final PatientProfile profile;
  const _GreetingHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Antes había una "esterilla" decorativa aquí (un óvalo de
        // color detrás de la mascota) — la quitamos porque la
        // ilustración real ya trae su propia sombra incorporada, y
        // la esterilla extra se veía como un elemento suelto sin
        // sentido junto a la imagen nueva.
        const MascotAvatar(size: 84, pose: MascotPose.saludando),
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

/// --- Tarjeta de progreso semanal ---
class _WeeklyProgressCard extends ConsumerWidget {
  final int profileId;
  const _WeeklyProgressCard({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return StreamBuilder<List<Session>>(
      stream: (db.select(db.sessions)..where((s) => s.profileId.equals(profileId))).watch(),
      builder: (context, snapshot) {
        final allSessions = snapshot.data ?? [];
        // .toLocal(): drift guarda las fechas en UTC; sin convertir,
        // una sesión hecha de noche en RD (UTC-4) podría contarse mal
        // al comparar contra la fecha de hoy en tu hora local.
        final sessionsThisWeek = allSessions
            .where((s) => s.date.toLocal().isAfter(sevenDaysAgo))
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

/// --- Tarjeta de la rutina del día ---
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
                    Text('Rutina de hoy', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(injury.name, style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      'Fase ${profile.currentPhase} · ${exercises.length} ejercicios',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: exercises.isEmpty
                            ? null
                            : () => context.push('/exercise-session', extra: exercises),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Comenzar sesión de hoy'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Puerta de entrada al catálogo completo (con las
                    // pestañas de Fase 1/2/3) — sin esto, no había forma
                    // de volver a ver ejercicios de una fase anterior.
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.push('/exercises'),
                        icon: const Icon(Icons.list_alt, size: 18),
                        label: const Text('Ver catálogo completo de ejercicios'),
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