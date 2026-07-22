import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/scroll_to_top_fab.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/mascot_avatar.dart';

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

  void _shareProgressSummary(
    PatientProfile profile,
    List<Session> sessions,
    List<PainLog> painLogs,
  ) {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final sessionsThisWeek =
        sessions.where((s) => s.date.toLocal().isAfter(sevenDaysAgo)).length;
    final lastPain = painLogs.isNotEmpty ? painLogs.last.painLevel : null;

    final buffer = StringBuffer()
      ..writeln('📋 Resumen de progreso — RehabIA')
      ..writeln('Paciente: ${profile.name}')
      ..writeln('Fase actual: ${profile.currentPhase}')
      ..writeln('Sesiones totales: ${sessions.length}')
      ..writeln('Sesiones esta semana: $sessionsThisWeek');

    if (lastPain != null) {
      buffer.writeln('Último nivel de dolor reportado: $lastPain/10');
    }
    buffer
      ..writeln('')
      ..writeln('Generado desde la app RehabIA.');

    Share.share(buffer.toString().trim());
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => _shareProgressSummary(profile, sessions, painLogs),
                          icon: const Icon(Icons.ios_share, size: 18),
                          label: const Text('Compartir resumen'),
                        ),
                      ),
                      const SizedBox(height: 12),
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
  final List<Session> sessions;

  const _StreakAndWeekRow({required this.sessions});

  int get _streakDays {
    // IMPORTANTE: convertimos cada fecha a hora LOCAL antes de sacar
    // el "día calendario". drift guarda las fechas en UTC por dentro;
    // si no convertimos, una sesión hecha a las 9pm en RD (UTC-4)
    // podría contarse como si hubiera sido al día siguiente.
    final days = sessions
        .map((s) => s.date.toLocal())
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

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
    return sessions.where((s) => s.date.toLocal().isAfter(sevenDaysAgo)).length;
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

class _PainChart extends StatelessWidget {
  final List<PainLog> painLogs;

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
                          // .toLocal() también aquí, para que la fecha
                          // mostrada coincida con tu calendario real.
                          '${log.date.toLocal().day}/${log.date.toLocal().month}',
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

class _SessionHistoryTile extends StatelessWidget {
  final Session session;
  const _SessionHistoryTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final localDate = session.date.toLocal();
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
          '${localDate.day}/${localDate.month}/${localDate.year} · ${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}',
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