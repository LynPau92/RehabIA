import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/scroll_to_top_fab.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/mascot_avatar.dart';

/// Pantalla de Progreso (Módulo 4): racha de días, resumen semanal,
/// historial de dolor, e historial de sesiones — todo leído de las
/// tablas Sessions y PainLogs que ahora sí se están llenando.
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
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

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      backgroundColor: AppColors.background,
      floatingActionButton: ScrollToTopFab(
        visible: _showScrollTopButton,
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        ),
      ),
      body: StreamBuilder<PatientProfile?>(
        stream: (db.select(db.patientProfiles)
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1))
            .watchSingleOrNull(),
        builder: (context, profileSnapshot) {
          if (!profileSnapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: _ProgressSkeleton(),
            );
          }
          final profile = profileSnapshot.data;
          if (profile == null) {
            return const Center(child: Text('Aún no hay un perfil guardado.'));
          }

          return StreamBuilder<List<Session>>(
            stream: (db.select(db.sessions)
                  ..where((s) => s.profileId.equals(profile.id))
                  ..orderBy([(s) => OrderingTerm.desc(s.date)]))
                .watch(),
            builder: (context, sessionsSnapshot) {
              if (!sessionsSnapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: _ProgressSkeleton(),
                );
              }
              final sessions = sessionsSnapshot.data!;

              return StreamBuilder<List<PainLog>>(
                stream: (db.select(db.painLogs)
                      ..where((p) => p.profileId.equals(profile.id))
                      ..orderBy([(p) => OrderingTerm.desc(p.date)])
                      ..limit(7))
                    .watch(),
                builder: (context, painSnapshot) {
                  final painLogs = (painSnapshot.data ?? []).reversed.toList();

                  if (sessions.isEmpty) {
                    return _EmptyProgressState(scrollController: _scrollController);
                  }

                  return ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      _StreakAndWeekRow(sessions: sessions),
                      const SizedBox(height: 20),
                      if (painLogs.isNotEmpty) ...[
                        const _SectionTitle('Nivel de dolor reciente'),
                        const SizedBox(height: 12),
                        _PainChart(painLogs: painLogs),
                        const SizedBox(height: 20),
                      ],
                      const _SectionTitle('Historial de sesiones'),
                      const SizedBox(height: 12),
                      for (final session in sessions) _SessionHistoryTile(session: session),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}

/// --- Estado vacío con propósito (en vez de solo "no hay datos") ---
class _EmptyProgressState extends StatelessWidget {
  final ScrollController scrollController;
  const _EmptyProgressState({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 60),
        const Center(child: MascotAvatar(size: 100, pose: MascotPose.saludando)),
        const SizedBox(height: 20),
        const Text(
          'Todavía no tienes sesiones registradas',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 8),
        const Text(
          'Completa tu primera sesión de ejercicios desde Inicio y aquí vas a ver tu racha, tu progreso y tu nivel de dolor a través del tiempo.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// --- Racha de días consecutivos + resumen de la semana ---
class _StreakAndWeekRow extends StatelessWidget {
  final List<Session> sessions; // ya vienen ordenadas de más reciente a más antigua

  const _StreakAndWeekRow({required this.sessions});

  int get _streakDays {
    final days = sessions.map((s) => DateTime(s.date.year, s.date.month, s.date.day)).toSet();
    var cursor = DateTime.now();
    var streak = 0;
    if (!days.contains(DateTime(cursor.year, cursor.month, cursor.day))) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (days.contains(DateTime(cursor.year, cursor.month, cursor.day))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get _sessionsThisWeek {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return sessions.where((s) => s.date.isAfter(sevenDaysAgo)).length;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            iconColor: AppColors.alert,
            value: '$_streakDays',
            label: _streakDays == 1 ? 'día seguido' : 'días seguidos',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.event_available,
            iconColor: AppColors.success,
            value: '$_sessionsThisWeek',
            label: _sessionsThisWeek == 1 ? 'sesión esta semana' : 'sesiones esta semana',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

/// --- Gráfico simple de barras para el dolor reciente (sin paquetes externos) ---
class _PainChart extends StatelessWidget {
  final List<PainLog> painLogs; // ya en orden cronológico (más antiguo primero)

  const _PainChart({required this.painLogs});

  Color _colorForPain(int level) {
    if (level <= 3) return AppColors.success;
    if (level <= 6) return AppColors.assistant;
    return AppColors.alert;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final log in painLogs)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${log.painLevel}', style: const TextStyle(fontSize: 11)),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: (log.painLevel / 10) * 70 + 6,
                          decoration: BoxDecoration(
                            color: _colorForPain(log.painLevel),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${log.date.day}/${log.date.month}',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Una fila del historial de sesiones ---
class _SessionHistoryTile extends StatelessWidget {
  final Session session;
  const _SessionHistoryTile({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.success),
        ),
        title: Text(
          '${session.date.day}/${session.date.month}/${session.date.year}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${session.exercisesCompleted} de ${session.exercisesTotal} ejercicios · ${session.durationMinutes} min',
        ),
      ),
    );
  }
}

class _ProgressSkeleton extends StatelessWidget {
  const _ProgressSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 90, borderRadius: BorderRadius.circular(16))),
            const SizedBox(width: 12),
            Expanded(child: SkeletonBox(height: 90, borderRadius: BorderRadius.circular(16))),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonBox(width: 160, height: 18),
        const SizedBox(height: 12),
        SkeletonBox(height: 120, borderRadius: BorderRadius.circular(16)),
        const SizedBox(height: 20),
        for (int i = 0; i < 3; i++) ...[
          SkeletonBox(height: 64, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}