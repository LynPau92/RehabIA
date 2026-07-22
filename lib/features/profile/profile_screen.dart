import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';

/// Pantalla de Perfil: datos del paciente + sección informativa sobre
/// su lesión + opción de cambiar de lesión.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _changeInjury(BuildContext context, WidgetRef ref, PatientProfile profile) async {
    final db = ref.read(databaseProvider);
    final injuries = await db.select(db.injuries).get();

    if (!context.mounted) return;

    final selected = await showModalBottomSheet<Injury>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _InjuryPickerSheet(injuries: injuries, currentInjuryId: profile.injuryId),
    );

    if (selected == null || !context.mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Cambiar de lesión?'),
        content: Text(
          'Vas a cambiar a "${selected.name}". Tu fase se reiniciará a la '
          'Fase 1 con esta nueva lesión. Tu historial de sesiones '
          'anteriores no se borra, sigue guardado.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
        ],
      ),
    );

    if (confirm == true) {
      await (db.update(db.patientProfiles)..where((t) => t.id.equals(profile.id))).write(
        PatientProfilesCompanion(
          injuryId: Value(selected.id),
          currentPhase: const Value(1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      backgroundColor: AppColors.background,
      body: StreamBuilder<PatientProfile?>(
        stream: (db.select(db.patientProfiles)
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1))
            .watchSingleOrNull(),
        builder: (context, profileSnapshot) {
          final profile = profileSnapshot.data;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _ProfileInfoCard(profile: profile),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _changeInjury(context, ref, profile),
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Cambiar mi lesión'),
              ),
              const SizedBox(height: 20),
              if (profile.injuryId != null)
                FutureBuilder<Injury>(
                  future: (db.select(db.injuries)
                        ..where((i) => i.id.equals(profile.injuryId!)))
                      .getSingle(),
                  builder: (context, injurySnapshot) {
                    if (!injurySnapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    return _InjuryInfoSection(injury: injurySnapshot.data!);
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

/// --- Hoja para elegir una lesión nueva, agrupada por zona corporal ---
class _InjuryPickerSheet extends StatelessWidget {
  final List<Injury> injuries;
  final int? currentInjuryId;

  const _InjuryPickerSheet({required this.injuries, required this.currentInjuryId});

  static const Map<String, String> _regionLabels = {
    'miembro_inferior': '🦵 Miembro inferior',
    'miembro_superior': '🦾 Miembro superior',
    'tronco_columna': '🦴 Tronco y columna',
    'otras': '💥 Otras lesiones',
  };

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Injury>>{};
    for (final injury in injuries) {
      grouped.putIfAbsent(injury.bodyRegion, () => []).add(injury);
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Text('Elige tu lesión', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            for (final region in _regionLabels.keys)
              if (grouped[region] != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Text(_regionLabels[region]!, style: Theme.of(context).textTheme.titleLarge),
                ),
                for (final injury in grouped[region]!)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: injury.id == currentInjuryId ? AppColors.primary : AppColors.border,
                        width: injury.id == currentInjuryId ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => Navigator.pop(context, injury),
                      title: Text(injury.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(injury.focusDescription, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: injury.id == currentInjuryId
                          ? const Icon(Icons.check_circle, color: AppColors.success)
                          : const Icon(Icons.chevron_right),
                    ),
                  ),
              ],
          ],
        );
      },
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final PatientProfile profile;
  const _ProfileInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.assistant,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name,
                          style:
                              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${profile.age} años',
                          style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            _InfoRow(label: 'Peso', value: '${(profile.weightKg * 2.20462).toStringAsFixed(1)} lb'),
            _InfoRow(label: 'Fase actual', value: 'Fase ${profile.currentPhase}'),
            _InfoRow(
              label: 'Indicación médica',
              value: profile.hasMedicalIndication ? 'Sí' : 'No',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// --- Sección informativa: sobre la lesión + señales de alerta ---
class _InjuryInfoSection extends StatelessWidget {
  final Injury injury;
  const _InjuryInfoSection({required this.injury});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sobre tu lesión', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(injury.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  injury.focusDescription,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.alert.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.alert.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: AppColors.alert),
                  SizedBox(width: 8),
                  Text(
                    'Señales de alerta',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.alert),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                injury.redFlagsText,
                style: const TextStyle(color: AppColors.textPrimary, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}