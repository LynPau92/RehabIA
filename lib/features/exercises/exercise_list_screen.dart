import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/scroll_to_top_fab.dart';
import '../../core/widgets/skeleton_loader.dart';

/// Catálogo de ejercicios (Módulo 2 de los requerimientos).
///
/// Muestra los ejercicios de la lesión del paciente, organizados por
/// fase (1/2/3). Las fases posteriores a la fase actual del paciente
/// aparecen bloqueadas — regla de tu documento: no se avanza sin
/// confirmar que la fase anterior se completó sin dolor.
class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final _scrollController = ScrollController();
  bool _showScrollTopButton = false;
  int? _selectedPhase; // null hasta que sepamos la fase actual del perfil

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
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ejercicios')),
      floatingActionButton: ScrollToTopFab(
        visible: _showScrollTopButton,
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        ),
      ),
      body: FutureBuilder<PatientProfile?>(
        future: (db.select(db.patientProfiles)
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1))
            .getSingleOrNull(),
        builder: (context, profileSnapshot) {
          if (!profileSnapshot.hasData) {
            return const _ExerciseListSkeleton();
          }
          final profile = profileSnapshot.data;
          if (profile == null || profile.injuryId == null) {
            return const Center(child: Text('No hay una lesión seleccionada.'));
          }

          // La primera vez, mostramos la fase actual del paciente.
          _selectedPhase ??= profile.currentPhase;

          return FutureBuilder<Injury>(
            future: (db.select(db.injuries)..where((i) => i.id.equals(profile.injuryId!)))
                .getSingle(),
            builder: (context, injurySnapshot) {
              if (!injurySnapshot.hasData) {
                return const _ExerciseListSkeleton();
              }
              final injury = injurySnapshot.data!;

              return FutureBuilder<List<Exercise>>(
                future: (db.select(db.exercises)
                      ..where((e) => e.injuryId.equals(injury.id))
                      ..where((e) => e.phase.equals(_selectedPhase!))
                      ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
                    .get(),
                builder: (context, exSnapshot) {
                  final exercises = exSnapshot.data ?? [];

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Text(
                          injury.name,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _PhaseTabs(
                        currentUnlockedPhase: profile.currentPhase,
                        selectedPhase: _selectedPhase!,
                        onSelect: (phase) => setState(() => _selectedPhase = phase),
                      ),
                      Expanded(
                        child: exercises.isEmpty
                            ? const Center(
                                child: Text('No hay ejercicios para esta fase todavía.'),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                                itemCount: exercises.length,
                                itemBuilder: (context, index) {
                                  return _ExerciseCard(exercise: exercises[index]);
                                },
                              ),
                      ),
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

/// --- Pestañas de fase (1/2/3), con candado en las bloqueadas ---
class _PhaseTabs extends StatelessWidget {
  final int currentUnlockedPhase;
  final int selectedPhase;
  final ValueChanged<int> onSelect;

  const _PhaseTabs({
    required this.currentUnlockedPhase,
    required this.selectedPhase,
    required this.onSelect,
  });

  static const _labels = {1: 'Fase 1', 2: 'Fase 2', 3: 'Fase 3'};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        children: [1, 2, 3].map((phase) {
          final isUnlocked = phase <= currentUnlockedPhase;
          final isSelected = phase == selectedPhase;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (isUnlocked) {
                  onSelect(phase);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Completa la fase actual sin dolor para desbloquear esta.',
                      ),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isUnlocked)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.lock, size: 14, color: AppColors.textSecondary),
                      ),
                    Text(
                      _labels[phase]!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// --- Tarjeta de un ejercicio individual ---
class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseCard({required this.exercise});

  /// Traduce los campos crudos de la base de datos (sets/reps/holdSeconds)
  /// a un texto legible, según el tipo de dosificación.
  String get _dosageText {
    switch (exercise.dosageType) {
      case 'isometrico':
        return '${exercise.sets ?? 1} series · sostener ${exercise.holdSeconds ?? 8} seg';
      case 'estiramiento':
        return 'Mantener ${exercise.holdSeconds ?? 25} segundos';
      case 'repeticiones':
      default:
        return '${exercise.sets ?? 2} series x ${exercise.reps ?? 12} repeticiones';
    }
  }

  IconData get _dosageIcon {
    switch (exercise.dosageType) {
      case 'isometrico':
        return Icons.timer_outlined;
      case 'estiramiento':
        return Icons.self_improvement;
      default:
        return Icons.repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias, // para que el efecto de "tap" respete las esquinas redondeadas
      child: InkWell(
        onTap: () => context.push('/exercise-session', extra: [exercise]),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_dosageIcon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dosageText,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
        ),
      ),
    );
  }
}

/// --- Skeleton del catálogo de ejercicios (imita las pestañas + tarjetas) ---
class _ExerciseListSkeleton extends StatelessWidget {
  const _ExerciseListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 140, height: 14),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SkeletonBox(
                    height: 40,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < 4; i++) ...[
            SkeletonBox(height: 76, borderRadius: BorderRadius.circular(16)),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}