import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';

/// Pantalla de Perfil: datos del paciente + sección informativa sobre
/// su lesión (Módulo 5), incluyendo las señales de alerta ("red flags")
/// que ya guardamos en el catálogo desde el Paso 2b.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
        // Tarjeta de señales de alerta, con color de "alert" para que
        // destaque claramente frente al resto del contenido.
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